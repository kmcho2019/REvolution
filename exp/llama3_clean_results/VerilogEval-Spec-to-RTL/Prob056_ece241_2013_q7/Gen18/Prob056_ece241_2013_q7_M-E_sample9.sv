module TopModule(
    input clk,
    input j,
    input k,
    output reg Q = 0 // Initialize Q to 0 for predictable behavior
);

reg [1:0] state = 2'b00; // Initialize state to 0 (S0)

always @(posedge clk) begin
    case ({j, k})
        2'b00: state <= state; // No change
        2'b01: state <= 2'b00; // Reset
        2'b10: state <= 2'b01; // Set
        2'b11: state <= ~state; // Toggle
    endcase
end

always @(*) begin
    case (state)
        2'b00: Q = 1'b0; // S0 corresponds to Q = 0
        2'b01: Q = 1'b1; // S1 corresponds to Q = 1
    endcase
end

endmodule