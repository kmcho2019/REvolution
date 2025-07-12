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

wire enable0, enable1, enable2, enable3, enable4, enable5;

// Direct decoding of select signal to enable signals
assign enable0 = (sel == 3'b000);
assign enable1 = (sel == 3'b001);
assign enable2 = (sel == 3'b010);
assign enable3 = (sel == 3'b011);
assign enable4 = (sel == 3'b100);
assign enable5 = (sel == 3'b101);

// Select data input based on enable signals
always @(*) begin
    if (enable0) out = data0;
    else if (enable1) out = data1;
    else if (enable2) out = data2;
    else if (enable3) out = data3;
    else if (enable4) out = data4;
    else if (enable5) out = data5;
    else out = 4'b0; // Default to 0 if none of the above conditions are met
end

endmodule