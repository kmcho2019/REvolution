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

reg [3:0] data_array [5:0];

always @(*) begin
    // Initialize the array with the input data
    data_array[0] = data0;
    data_array[1] = data1;
    data_array[2] = data2;
    data_array[3] = data3;
    data_array[4] = data4;
    data_array[5] = data5;

    // Use a case statement to handle the select signal and assign the output
    case (sel)
        3'b000: out = data_array[0];
        3'b001: out = data_array[1];
        3'b010: out = data_array[2];
        3'b011: out = data_array[3];
        3'b100: out = data_array[4];
        3'b101: out = data_array[5];
        default: out = 4'b0; // Default condition for invalid select signals
    endcase
end

endmodule