module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire tap_22 = q[22] ^ q[0];
wire tap_2 = q[2] ^ q[0];
wire tap_1 = q[1] ^ q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {q[0], q[31:23], tap_22, q[21:3], tap_2, tap_1};
    end
end

endmodule