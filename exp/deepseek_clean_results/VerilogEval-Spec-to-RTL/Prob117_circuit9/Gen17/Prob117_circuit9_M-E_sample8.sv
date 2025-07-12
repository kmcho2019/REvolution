module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] sr;

always @(posedge clk) begin
    if (a) begin
        sr <= 3'b100;  // Force to 4 when a is high
    end else begin
        // Custom shift register with feedback to generate 4-5-6-0-1 sequence
        sr <= {sr[1:0], sr[2] ^ sr[1]};
    end
end

assign q = sr;

endmodule