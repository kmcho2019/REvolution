module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Byte reversal using shift-register inspired logic
    wire [7:0] byte3 = in[31:24];
    wire [7:0] byte2 = in[23:16];
    wire [7:0] byte1 = in[15:8];
    wire [7:0] byte0 = in[7:0];
    
    // Shift-register inspired byte ordering
    assign out = {byte0, byte1, byte2, byte3};
    
    // Alternative implementation showing the shift concept:
    // assign out[31:24] = byte0;
    // assign out[23:16] = byte1;
    // assign out[15:8]  = byte2;
    // assign out[7:0]   = byte3;
endmodule