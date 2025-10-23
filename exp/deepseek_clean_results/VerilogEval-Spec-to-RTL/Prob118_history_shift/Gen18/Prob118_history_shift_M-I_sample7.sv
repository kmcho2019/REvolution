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
    wire [31:0] next_history;

    // Clock gating cell would be inserted here during synthesis
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
        end else if (update_enable) begin
            history_reg <= next_history;
        end
    end

    // Two-stage shift operation for better timing
    wire [15:0] upper_half = train_mispredicted ? train_history[30:15] : history_reg[30:15];
    wire [15:0] lower_half = train_mispredicted ? {train_history[14:0], train_taken} : 
                               predict_valid ? {history_reg[14:0], predict_taken} : 
                               history_reg[15:0];

    assign next_history = {upper_half, lower_half};
    assign predict_history = history_reg;

endmodule