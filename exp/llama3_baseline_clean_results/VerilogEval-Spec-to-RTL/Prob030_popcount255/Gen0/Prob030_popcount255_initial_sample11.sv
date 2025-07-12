module TopModule(
    input [255:0] in,
    output [7:0] out
);

// Define a module to count the number of '1's in a byte
module byte_count(
    input [7:0] byte_in,
    output [3:0] byte_out
);
    assign byte_out = {1'b0, byte_in[0]} + {1'b0, byte_in[1]} + {1'b0, byte_in[2]} + {1'b0, byte_in[3]} + 
                       {1'b0, byte_in[4]} + {1'b0, byte_in[5]} + {1'b0, byte_in[6]} + {1'b0, byte_in[7]};
endmodule

// Instantiate 32 byte_count modules to count the number of '1's in each byte of the input
wire [3:0] byte_counts [31:0];
genvar i;
generate
    for (i = 0; i < 32; i = i + 1) begin
        byte_count bc(
            .byte_in(in[(i*8)+7:i*8]),
            .byte_out(byte_counts[i])
        );
    end
endgenerate

// Define a module to sum up the byte counts
module sum_byte_counts(
    input [3:0] counts [31:0],
    output [7:0] sum_out
);
    reg [7:0] sum_out_reg;
    always @(*) begin
        sum_out_reg = 0;
        for (int i = 0; i < 32; i = i + 1) begin
            sum_out_reg = sum_out_reg + counts[i];
        end
        sum_out = sum_out_reg;
    end
endmodule

// Instantiate the sum_byte_counts module to sum up the byte counts
sum_byte_counts sbc(
    .counts(byte_counts),
    .sum_out(out)
);

endmodule