module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] padded_q = {1'b0, q, 1'b0};
    wire [511:0] q_next;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : update_bits
            assign q_next[i] = padded_q[i] ^ padded_q[i+2];
        end
    endgenerate

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule