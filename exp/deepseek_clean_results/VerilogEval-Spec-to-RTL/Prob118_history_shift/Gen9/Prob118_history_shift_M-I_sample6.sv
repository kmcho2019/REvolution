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
    wire update_enable = predict_valid | train_mispredicted;
    reg clk_gated;

    // Clock gating logic
    always @(*) begin
        clk_gated = clk & (areset | update_enable);
    end

    assign predict_history = history;

    // Two-stage pipelined shift implementation
    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // First stage: lower 16 bits
                history[15:0] <= {train_history[14:0], train_taken};
                // Second stage: upper 16 bits
                history[31:16] <= train_history[30:15];
            end else if (predict_valid) begin
                // First stage: lower 16 bits
                history[15:0] <= {history[14:0], predict_taken};
                // Second stage: upper 16 bits
                history[31:16] <= history[30:15];
            end
        end
    end

endmodule