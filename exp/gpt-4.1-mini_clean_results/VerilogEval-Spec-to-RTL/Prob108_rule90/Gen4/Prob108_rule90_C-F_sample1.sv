module Rule90Block64 (
    input clk,
    input load,
    input [63:0] data_in,
    output reg [63:0] q_out
);
    wire [63:0] next_state;

    genvar i;
    generate
        for (i = 0; i < 64; i = i + 1) begin : calc_next
            // For internal bits, neighbors are q_out[i-1], q_out[i+1]
            // For edges, neighbors are zero because no wrap-around or inter-block connections
            wire left = (i == 0) ? 1'b0 : q_out[i-1];
            wire right= (i == 63)? 1'b0 : q_out[i+1];
            assign next_state[i] = left ^ right;
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q_out <= data_in;
        else
            q_out <= next_state;
    end
endmodule

module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    wire [63:0] block_q [7:0];

    genvar blk;
    generate
        for (blk = 0; blk < 8; blk = blk + 1) begin : blocks
            Rule90Block64 block (
                .clk(clk),
                .load(load),
                .data_in(data[blk*64 +: 64]),
                .q_out(block_q[blk])
            );
            assign q[blk*64 +: 64] = block_q[blk];
        end
    endgenerate

endmodule