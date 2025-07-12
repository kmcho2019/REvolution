module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_state;
wire tap_xor;

assign tap_xor = q[31] ^ q[21] ^ q[1];
assign next_state = {tap_xor ^ q[0], q[31:1]};

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= next_state;
    end
end

endmodule