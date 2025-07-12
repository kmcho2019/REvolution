module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Separate byte registers
    reg [7:0] byte3, byte2, byte1, byte0;
    
    always @(*) begin
        // Load bytes from input
        byte3 = in[31:24];
        byte2 = in[23:16];
        byte1 = in[15:8];
        byte0 = in[7:0];
        
        // Wire outputs in reverse order
        out = {byte0, byte1, byte2, byte3};
    end
endmodule