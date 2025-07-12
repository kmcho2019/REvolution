module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history;
    wire [31:0] mispred_update = {train_history[30:0], train_taken};
    wire [31:0] pred_update = {history[30:0], predict_taken};
    wire update_en = predict_valid | train_mispredicted;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history[15:0] <= 16'b0;  // Async reset for critical lower bits
        end else if (update_en) begin
            if (train_mispredicted) begin
                history <= mispred_update;
            end else begin
                history <= pred_update;
            end
        end
    end

    // Synchronous reset for upper bits to save area
    always @(posedge clk) begin
        if (areset) begin
            history[31:16] <= 16'b0;
        end
    end

    // Clock gating for prediction path
    wire gated_clk = clk & (predict_valid & ~train_mispredicted);
    always @(posedge gated_clk) begin
        if (~areset) begin
            history[0] <= predict_taken;
            history[31:1] <= history[30:0];
        end
    end

    assign predict_history = history;

endmodule