// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);
    
    reg [7:0] sum;
    reg Co;
    
    // Calculate sum and carry for each bit
    always @(*) begin
        sum[0] = a[0] ^ b[0] ^ Cin;
        Co = (a[0] & b[0]) | (a[0] & Cin) | (b[0] & Cin);
        
        // For bits 1 to 7
        for (int i = 1; i < 8; i++) begin
            reg carry_i;
            carry_i = (a[i-1] & b[i-1]) | (a[i-1] & sum[i-1]) | (b[i-1] & sum[i-1]);
            sum[i] = a[i] ^ b[i] ^ carry_i;
            if (i == 7)
                Co = (a[i] & b[i]) | (a[i] & carry_i) | (b[i] & carry_i);
        end
    end
    
    // Assign output
    assign y = sum;
endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    
    wire C1;
    
    // Instantiate two 8-bit adders
    adder_8bit adder_lower(
       .a(a[7:0]),
       .b(b[7:0]),
       .Cin(Cin),
       .y(y[7:0]),
       .Co(C1)
    );
    
    adder_8bit adder_upper(
       .a(a[15:8]),
       .b(b[15:8]),
       .Cin(C1),
       .y(y[15:8]),
       .Co(Co)
    );
endmodule