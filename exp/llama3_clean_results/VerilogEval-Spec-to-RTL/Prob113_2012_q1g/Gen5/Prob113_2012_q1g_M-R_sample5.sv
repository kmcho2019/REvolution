module TopModule(
    input [3:0] x,
    output f
);

// Define conditions based on x[2]x[3]
wire case_00 = (x[2] == 1'b0 && x[3] == 1'b0);
wire case_11 = (x[2] == 1'b1 && x[3] == 1'b1);
wire case_10 = (x[2] == 1'b1 && x[3] == 1'b0);

// Define conditions based on x[0]x[1]
wire x01 = (x[0] == 1'b0 && x[1] == 1'b1);
wire x11 = (x[0] == 1'b1 && x[1] == 1'b1);
wire x10 = (x[0] == 1'b1 && x[1] == 1'b0);
wire x00 = (x[0] == 1'b0 && x[1] == 1'b0);

// Define output f based on conditions
assign f = (case_00 && (x00 || x10)) ||
           (case_11 && (x00 || x01 || x11)) ||
           (case_10 && (x00 || x01 || x10));

endmodule