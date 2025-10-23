module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

reg [511:0] next_q;
wire [513:0] extended_q = {1'b0, q, 1'b0};

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    for (integer i = 0; i < 512; i = i + 1) begin
        next_q[i] = extended_q[i] ^ extended_q[i+2];
    end
end

endmodule