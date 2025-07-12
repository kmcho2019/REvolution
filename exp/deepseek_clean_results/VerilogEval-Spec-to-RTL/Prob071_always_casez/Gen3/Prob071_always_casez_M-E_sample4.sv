module TopModule (
    input [7:0] in,
    output [2:0] pos
);

wire [1:0] chunk_sel;
wire [3:0] chunk0 = in[3:0];
wire [3:0] chunk1 = in[7:4];

// Determine which chunk has the first '1'
assign chunk_sel = |chunk0 ? 2'b00 : 2'b01;

// Priority encoders for each chunk
wire [1:0] pos_chunk0;
assign pos_chunk0 = chunk0[0] ? 2'b00 :
                   chunk0[1] ? 2'b01 :
                   chunk0[2] ? 2'b10 :
                   chunk0[3] ? 2'b11 : 2'b00;

wire [1:0] pos_chunk1;
assign pos_chunk1 = chunk1[0] ? 2'b00 :
                   chunk1[1] ? 2'b01 :
                   chunk1[2] ? 2'b10 :
                   chunk1[3] ? 2'b11 : 2'b00;

// Final output mux
assign pos = chunk_sel[1] ? {1'b1, pos_chunk1} : 
                            {1'b0, pos_chunk0};

endmodule