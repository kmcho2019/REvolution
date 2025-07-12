module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

localparam TAP_0 = 0;
localparam TAP_1 = 1;
localparam TAP_2 = 21;
localparam TAP_3 = 31;

reg [31:0] next_q;

always @(*) begin
    next_q = q;
    next_q[31] = q[TAP_3] ^ q[TAP_2] ^ q[TAP_1] ^ q[TAP_0];
    for (int i = 0; i < 31; i++) begin
        next_q[i] = q[i+1];
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        q <= next_q;
    end
end

endmodule