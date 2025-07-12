module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Temporary 32-bit register to hold all bits
    reg [31:0] temp_reg;

    always @(*) begin
        // Initialize with all zeros
        temp_reg = 32'b0;
        
        // Insert each input at specific bit positions
        temp_reg[31:27] = a;    // bits 31-27
        temp_reg[26:22] = b;    // bits 26-22
        temp_reg[21:17] = c;    // bits 21-17
        temp_reg[16:12] = d;    // bits 16-12
        temp_reg[11:7]  = e;    // bits 11-7
        temp_reg[6:2]   = f;    // bits 6-2
        
        // Add padding bits (2'b11) at LSB positions
        temp_reg[1:0] = 2'b11;
    end

    // Distribute the bits to outputs
    assign w = temp_reg[31:24];
    assign x = temp_reg[23:16];
    assign y = temp_reg[15:8];
    assign z = temp_reg[7:0];

endmodule