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
    wire update_enable = predict_valid | train_mispredicted;
    wire clk_gated;

    // Clock gating cell
    CLK_GATE clk_gate_inst (
        .CLK(clk),
        .EN(update_enable),
        .GCLK(clk_gated)
    );

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else begin
            // Two-stage pipelined shift operation
            if (train_mispredicted) begin
                // First stage: lower 16 bits
                history_reg[15:0] <= {train_history[14:0], train_taken};
                // Second stage: upper 16 bits
                history_reg[31:16] <= train_history[30:15];
            end else if (predict_valid) begin
                // First stage: lower 16 bits
                history_reg[15:0] <= {history_reg[14:0], predict_taken};
                // Second stage: upper 16 bits
                history_reg[31:16] <= history_reg[30:15];
            end
        end
    end

    assign predict_history = history_reg;

endmodule