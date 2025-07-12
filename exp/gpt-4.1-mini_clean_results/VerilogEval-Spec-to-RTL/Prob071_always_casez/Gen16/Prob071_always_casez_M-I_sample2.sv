module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

wire [3:0] half_pos;
wire half_sel;

// Check upper 4 bits: bits[7:4]
wire upper_valid = |in[7:4];
// Check lower 4 bits: bits[3:0]
wire lower_valid = |in[3:0];

// Determine if the set bit is in upper half or lower half
assign half_sel = upper_valid;

// Binary search on 4 bits
wire [1:0] lower_pos;
wire lower_half_sel;
wire [1:0] upper_pos;
wire upper_half_sel;

assign lower_half_sel = |in[3:2];
assign lower_pos = lower_half_sel ? (in[3] ? 2'd3 : 2'd2) :
                 (|in[1:0] ? (in[1] ? 2'd1 : 2'd0) : 2'd0);

assign upper_half_sel = |in[7:6];
assign upper_pos = upper_half_sel ? (in[7] ? 2'd3 : 2'd2) :
                 (|in[5:4] ? (in[5] ? 2'd1 : 2'd0) : 2'd0);

// Combine results
assign half_pos = half_sel ? ( {1'b1, upper_pos} ) : ( {1'b0, lower_pos} );

// Output zero if no bits set
assign pos = (|in) ? half_pos : 3'd0;

endmodule