module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        case (state_reg)
            2'b00: state_reg <= train_valid && train_taken ? 2'b01 : 2'b00;
            2'b01: state_reg <= train_valid ? (train_taken ? 2'b10 : 2'b00) : 2'b01;
            2'b10: state_reg <= train_valid ? (train_taken ? 2'b11 : 2'b01) : 2'b10;
            2'b11: state_reg <= train_valid && !train_taken ? 2'b10 : 2'b11;
            default: state_reg <= 2'b01; // Default case for unexpected values
        endcase
    end
end

endmodule