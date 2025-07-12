module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

// Precompute byte masks for upper and lower bytes
wire [15:0] upper_mask = {8{byteena[1]}};
wire [15:0] lower_mask = {8{byteena[0]}};

// Combine masks for full 16-bit byte enables
wire [15:0] full_mask = {upper_mask[7:0], lower_mask[7:0]}; // upper_mask is already 8 bits replicated

// Next state logic with masking and data selection
wire [15:0] next_q = (q & ~full_mask) | (d & full_mask);

always @(posedge clk) begin
    if (!resetn)
        q <= 16'b0;
    else
        q <= next_q;
end

endmodule