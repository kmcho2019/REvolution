module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

wire [23:0] dividend = {8'b0, A};
wire [15:0] divisor = {8'b0, B};

// Parallel comparison units
wire [15:0] diff [0:15];
wire [15:0] cmp_res [0:15];
wire [23:0] partial_remainder [0:15];

// Stage 0: Initial comparison
assign diff[0] = dividend[23:8] - divisor;
assign cmp_res[0] = {15'b0, ~diff[0][15]};
assign partial_remainder[0] = diff[0][15] ? 
    {dividend[23:8], dividend[7:0], 1'b0} : 
    {diff[0], dividend[7:0], 1'b0};

// Pipeline stages 1-15
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : div_stages
        assign diff[i] = partial_remainder[i-1][23:8] - divisor;
        assign cmp_res[i] = {cmp_res[i-1][15:1], ~diff[i][15]};
        assign partial_remainder[i] = diff[i][15] ? 
            {partial_remainder[i-1][23:8], partial_remainder[i-1][7:0], 1'b0} : 
            {diff[i], partial_remainder[i-1][7:0], 1'b0};
    end
endgenerate

// Final outputs
assign result = (B == 8'b0) ? 16'hFFFF : cmp_res[15];
assign odd = (B == 8'b0) ? 16'hFFFF : {8'b0, partial_remainder[15][23:16]};

endmodule