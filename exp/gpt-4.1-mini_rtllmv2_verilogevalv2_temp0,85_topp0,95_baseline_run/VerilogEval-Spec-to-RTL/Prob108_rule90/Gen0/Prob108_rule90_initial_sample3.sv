module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Pad q with zeros on both ends
            // left_neighbors = {q[510:0], 1'b0}
            // right_neighbors = {1'b0, q[511:1]}
            // next_q[i] = left_neighbors[i] ^ right_neighbors[i]
            q <= ({q[510:0], 1'b0}) ^ ({1'b0, q[511:1]});
        end
    end

endmodule