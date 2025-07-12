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

// First level of multiplexers
reg [3:0] mid0, mid1;

always @(*) begin
    // Select between data0, data1, and data2
    case (sel[1:0])
        2'b00: mid0 = data0;
        2'b01: mid0 = data1;
        2'b10: mid0 = data2;
        default: mid0 = 4'b0000;
    endcase
    
    // Select between data3, data4, and data5
    case (sel[1:0])
        2'b00: mid1 = data3;
        2'b01: mid1 = data4;
        2'b10: mid1 = data5;
        default: mid1 = 4'b0000;
    endcase
end

// Second level of multiplexers
always @(*) begin
    // Select the final output based on the most significant bit of sel
    case (sel[2])
        1'b0: out = mid0;
        1'b1: out = mid1;
        default: out = 4'b0000;
    endcase
end

endmodule