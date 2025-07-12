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

    reg [31:0] history_reg;
    wire reg_enable = predict_valid | train_mispredicted;
    wire clk_gated = clk & reg_enable;

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            if (train_mispredicted) begin
                // Split into two 16-bit segments for better timing
                history_reg[31:16] <= train_history[30:15];
                history_reg[15:0] <= {train_history[14:0], train_taken};
            end else if (predict_valid) begin
                // Split shift operation
                history_reg[31:16] <= history_reg[30:15];
                history_reg[15:0] <= {history_reg[14:0], predict_taken};
            end
        end
    end

    assign predict_history = history_reg;

endmodule