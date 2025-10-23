module TopModule (
    input [2:0] sel,
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output [3:0] out
);

// Create one-hot encoded select signals
wire [5:0] select_lines;
assign select_lines[0] = (sel == 3'd0);
assign select_lines[1] = (sel == 3'd1);
assign select_lines[2] = (sel == 3'd2);
assign select_lines[3] = (sel == 3'd3);
assign select_lines[4] = (sel == 3'd4);
assign select_lines[5] = (sel == 3'd5);

// Mask each data input with its select line
wire [3:0] masked_data0 = data0 & {4{select_lines[0]}};
wire [3:0] masked_data1 = data1 & {4{select_lines[1]}};
wire [3:0] masked_data2 = data2 & {4{select_lines[2]}};
wire [3:0] masked_data3 = data3 & {4{select_lines[3]}};
wire [3:0] masked_data4 = data4 & {4{select_lines[4]}};
wire [3:0] masked_data5 = data5 & {4{select_lines[5]}};

// Combine all masked data inputs
assign out = masked_data0 | masked_data1 | masked_data2 | 
              masked_data3 | masked_data4 | masked_data5;

endmodule