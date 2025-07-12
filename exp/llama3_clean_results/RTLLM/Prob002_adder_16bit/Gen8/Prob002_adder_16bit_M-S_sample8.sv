// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire [15:0] sum;
    reg [15:0] carry;
    reg [15:0] temp;
    
    // Calculate sum and carry for each bit
    always @(*)
    begin
        carry[0] = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
        sum[0] = a[0] ^ b[0] ^ Cin;
        
        for (int i = 1; i < 16; i++)
        begin
            carry[i] = (a[i] & b[i]) | (a[i] & carry[i-1]) | (b[i] & carry[i-1]);
            sum[i] = a[i] ^ b[i] ^ carry[i-1];
        end
    end
    
    // Assign output
    assign y = sum;
    assign Co = carry[15];
endmodule