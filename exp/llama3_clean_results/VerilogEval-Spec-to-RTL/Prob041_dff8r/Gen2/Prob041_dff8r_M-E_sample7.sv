module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

reg [7:0] internal_q;

always @(posedge clk) begin
    if (reset) begin
        internal_q <= {internal_q[6:0], 1'b0}; // Shift reset through the register
    end else begin
        internal_q <= {d[7], internal_q[7:1]}; // Shift data through the register
    end
end

assign q = internal_q;

endmodule