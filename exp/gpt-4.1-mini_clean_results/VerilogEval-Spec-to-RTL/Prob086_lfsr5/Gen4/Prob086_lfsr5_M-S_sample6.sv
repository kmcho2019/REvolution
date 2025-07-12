module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[0];
wire tap_xor = feedback ^ q[2]; // taps at positions 5 (q[4]) and 3 (q[2]) mean XOR at q[2] with feedback

always @(posedge clk) begin
    if (reset)
        q <= 5'b00001;
    else
        q <= {tap_xor, q[4:1]};
end

endmodule