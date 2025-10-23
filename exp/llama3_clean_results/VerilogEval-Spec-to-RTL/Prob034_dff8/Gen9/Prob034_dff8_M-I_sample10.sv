module TopModule(
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

// Use a single always block for all flip-flops
always @(posedge clk) begin
    // Update each bit of 'q' with the corresponding bit of 'd' at the positive edge of the clock
    q <= d;
end

endmodule