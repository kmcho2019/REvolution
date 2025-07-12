module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] q_next;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : update_bits
            wire left_neighbor  = (i == 0)   ? 1'b0 : q[i-1];
            wire right_neighbor = (i == 511) ? 1'b0 : q[i+1];
            assign q_next[i] = left_neighbor ^ right_neighbor;
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