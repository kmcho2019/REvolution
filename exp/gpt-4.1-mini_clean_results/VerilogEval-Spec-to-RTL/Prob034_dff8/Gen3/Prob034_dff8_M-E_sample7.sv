module ShiftRegister8 (
    input clk,
    input [7:0] d,
    output reg [7:0] q
);
    // On each clock edge, load the input vector d into the shift register q
    always @(posedge clk) begin
        // Parallel load the entire 8-bit input into the register
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);
    // Instantiate the 8-bit shift register
    ShiftRegister8 shiftreg_inst (
        .clk(clk),
        .d(d),
        .q(q)
    );
endmodule