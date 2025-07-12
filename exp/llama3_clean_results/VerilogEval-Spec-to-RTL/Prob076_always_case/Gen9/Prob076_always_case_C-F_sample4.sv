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
    
    // Concatenate all data inputs
    data_concat = {data5, data4, data3, data2, data1, data0};
    
    // Use case statement to select the appropriate 4-bit segment
    case (sel)
        3'b000: out = data_concat[3:0];
        3'b001: out = data_concat[7:4];
        3'b010: out = data_concat[11:8];
        3'b011: out = data_concat[15:12];
        3'b100: out = data_concat[19:16];
        3'b101: out = data_concat[23:20];
        default: out = 4'b0000; // Default to 0 for other sel values
    endcase
end

endmodule