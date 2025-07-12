module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    wire [15:0] count_16bit [15:0];

    // Level 1: Count the number of '1's in each 16-bit chunk
    genvar i;
    generate
        for (i = 0; i < 15; i++) begin
            population_count_16bit population_count_16bit_inst (
               .in(in[16*i + 15 : 16*i]),
               .out(count_16bit[i])
            );
        end
        population_count_7bit population_count_7bit_inst (
           .in(in[255:249]),
           .out(count_16bit[15])
        );
    endgenerate

    // Level 2: Combine the partial counts from each 16-bit chunk
    wire [15:0] count_4bit [3:0];
    generate
        for (i = 0; i < 4; i++) begin
            adder_16bit adder_16bit_inst (
               .in0(count_16bit[4*i + 0]),
               .in1(count_16bit[4*i + 1]),
               .in2(count_16bit[4*i + 2]),
               .in3(count_16bit[4*i + 3]),
               .out(count_4bit[i])
            );
        end
    endgenerate

    // Level 3: Combine the partial counts from each 4-bit chunk
    wire [15:0] count_2bit [1:0];
    generate
        for (i = 0; i < 2; i++) begin
            adder_16bit adder_16bit_inst (
               .in0(count_4bit[2*i + 0]),
               .in1(count_4bit[2*i + 1]),
               .in2(16'd0),
               .in3(16'd0),
               .out(count_2bit[i])
            );
        end
    endgenerate

    // Level 4: Combine the partial counts from each 2-bit chunk
    wire [15:0] count_final;
    adder_16bit adder_16bit_inst (
       .in0(count_2bit[0]),
       .in1(count_2bit[1]),
       .in2(16'd0),
       .in3(16'd0),
       .out(count_final)
    );

    // Output the final population count
    assign out = count_final[7:0];

endmodule

// Helper module to count the number of '1's in a 16-bit vector
module population_count_16bit(
    input  [15:0] in,
    output [15:0] out
);
    assign out = {12'd0, in[0]} + {12'd0, in[1]} + {12'd0, in[2]} + {12'd0, in[3]} +
                 {12'd0, in[4]} + {12'd0, in[5]} + {12'd0, in[6]} + {12'd0, in[7]} +
                 {12'd0, in[8]} + {12'd0, in[9]} + {12'd0, in[10]} + {12'd0, in[11]} +
                 {12'd0, in[12]} + {12'd0, in[13]} + {12'd0, in[14]} + {12'd0, in[15]};
endmodule

// Helper module to count the number of '1's in a 7-bit vector
module population_count_7bit(
    input  [6:0] in,
    output [15:0] out
);
    assign out = {12'd0, in[0]} + {12'd0, in[1]} + {12'd0, in[2]} + {12'd0, in[3]} +
                 {12'd0, in[4]} + {12'd0, in[5]} + {12'd0, in[6]};
endmodule

// Helper module to add four 16-bit numbers
module adder_16bit(
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [15:0] in3,
    output [15:0] out
);
    assign out = in0 + in1 + in2 + in3;
endmodule