module adder_8bit #(
    parameter WIDTH = 8,          // Configurable width
    parameter USE_GENERATE = 1    // 1=use generate loop, 0=explicit assignments
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Carry chain - array style for clear propagation visualization
    wire [WIDTH:0] carry;
    assign carry[0] = cin;

    generate
        if (USE_GENERATE) begin : gen_loop_adder
            // Compact generate loop implementation (better for large widths)
            genvar i;
            for (i = 0; i < WIDTH; i = i + 1) begin : bit_adder
                // Sum = a XOR b XOR carry_in
                assign sum[i] = a[i] ^ b[i] ^ carry[i];
                
                // Carry_out = (a AND b) OR (carry_in AND (a OR b))
                assign carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] | b[i]));
            end
        end else begin : explicit_adder
            // Explicit bit-level implementation (better for debugging)
            
            // Bit 0: LSB
            assign sum[0] = a[0] ^ b[0] ^ carry[0];
            assign carry[1] = (a[0] & b[0]) | (carry[0] & (a[0] | b[0]));
            
            // Bit 1
            assign sum[1] = a[1] ^ b[1] ^ carry[1];
            assign carry[2] = (a[1] & b[1]) | (carry[1] & (a[1] | b[1]));
            
            // Bit 2
            assign sum[2] = a[2] ^ b[2] ^ carry[2];
            assign carry[3] = (a[2] & b[2]) | (carry[2] & (a[2] | b[2]));
            
            // Bit 3
            assign sum[3] = a[3] ^ b[3] ^ carry[3];
            assign carry[4] = (a[3] & b[3]) | (carry[3] & (a[3] | b[3]));
            
            // Bit 4
            assign sum[4] = a[4] ^ b[4] ^ carry[4];
            assign carry[5] = (a[4] & b[4]) | (carry[4] & (a[4] | b[4]));
            
            // Bit 5
            assign sum[5] = a[5] ^ b[5] ^ carry[5];
            assign carry[6] = (a[5] & b[5]) | (carry[5] & (a[5] | b[5]));
            
            // Bit 6
            assign sum[6] = a[6] ^ b[6] ^ carry[6];
            assign carry[7] = (a[6] & b[6]) | (carry[6] & (a[6] | b[6]));
            
            // Bit 7: MSB
            assign sum[7] = a[7] ^ b[7] ^ carry[7];
            assign carry[8] = (a[7] & b[7]) | (carry[7] & (a[7] | b[7]));
        end
    endgenerate

    // Final carry out
    assign cout = carry[WIDTH];

endmodule