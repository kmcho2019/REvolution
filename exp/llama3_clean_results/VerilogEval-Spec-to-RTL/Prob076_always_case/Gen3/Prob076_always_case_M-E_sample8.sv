module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

always @(*) begin
    reg [23:0] data_concat;
    reg [23:0] shifted_data;
    
    // Concatenate all data inputs
    data_concat = {data5, data4, data3, data2, data1, data0};
    
    // Shift the concatenated data based on sel
    shifted_data = (data_concat >> (sel * 4));
    
    // Mask to get the 4-bit output
    out = shifted_data[3:0];
end

endmodule