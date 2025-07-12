module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

localparam TAP_0 = 0;
localparam TAP_1 = 1;
localparam TAP_2 = 21;
localparam TAP_3 = 31;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 32'h1; // Reset to 1
    end else begin
        reg [31:0] next_q;
        next_q = q;
        next_q[0] = q[TAP_3] ^ q[TAP_2] ^ q[TAP_1] ^ q[TAP_0];
        for (int i = 1; i < 32; i++) begin
            next_q[i] = q[i-1];
        end
        q <= next_q;
    end
end

endmodule