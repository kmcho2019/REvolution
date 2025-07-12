module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

    // Concatenate all data inputs into one vector
    wire [23:0] all_data = {data5, data4, data3, data2, data1, data0};

    // Calculate output using bit slicing with boundary check
    // If sel > 5, output zero
    wire valid_sel = (sel <= 3'd5);
    wire [4:0] sel_shift = {2'b00, sel} << 2; // sel * 4

    assign out = valid_sel ? all_data[sel_shift +: 4] : 4'b0000;

endmodule