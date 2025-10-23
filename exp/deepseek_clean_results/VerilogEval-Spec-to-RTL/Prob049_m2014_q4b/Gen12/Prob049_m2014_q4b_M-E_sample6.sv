module TopModule (
    input clk,
    input ar,
    input d,
    output q
);

wire master_out;

// Master latch (negative level-sensitive)
always @(negedge clk or posedge ar)
    if (ar) master_out <= 1'b0;
    else    master_out <= d;

// Slave latch (positive level-sensitive) with async reset
reg slave_out;
always @(posedge clk or posedge ar)
    if (ar) slave_out <= 1'b0;
    else    slave_out <= master_out;

assign q = slave_out;

endmodule