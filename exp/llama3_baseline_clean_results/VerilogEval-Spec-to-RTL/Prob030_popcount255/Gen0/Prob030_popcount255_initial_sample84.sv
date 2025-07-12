module TopModule (
    input  [254:0] in,
    output [7:0] out
);

    wire [4:0] count_8bit [31:0];
    wire [5:0] count_16bit [15:0];
    wire [6:0] count_32bit [7:0];
    wire [7:0] count_64bit [3:0];
    wire [8:0] count_128bit [1:0];
    wire [9:0] count_256bit;

    // Counting '1's in each 8-bit segment
    for (genvar i = 0; i < 32; i++) begin
        pop_count_8bit u_pop_count_8bit (
           .in(in[8*i + 7:8*i]),
           .out(count_8bit[i])
        );
    end

    // Counting '1's in each 16-bit segment (combining 8-bit counts)
    for (genvar i = 0; i < 16; i++) begin
        adder_5bit u_adder_5bit (
           .a(count_8bit[2*i]),
           .b(count_8bit[2*i + 1]),
           .out(count_16bit[i])
        );
    end

    // Counting '1's in each 32-bit segment (combining 16-bit counts)
    for (genvar i = 0; i < 8; i++) begin
        adder_6bit u_adder_6bit (
           .a(count_16bit[2*i]),
           .b(count_16bit[2*i + 1]),
           .out(count_32bit[i])
        );
    end

    // Counting '1's in each 64-bit segment (combining 32-bit counts)
    for (genvar i = 0; i < 4; i++) begin
        adder_7bit u_adder_7bit (
           .a(count_32bit[2*i]),
           .b(count_32bit[2*i + 1]),
           .out(count_64bit[i])
        );
    end

    // Counting '1's in each 128-bit segment (combining 64-bit counts)
    for (genvar i = 0; i < 2; i++) begin
        adder_8bit u_adder_8bit (
           .a(count_64bit[2*i]),
           .b(count_64bit[2*i + 1]),
           .out(count_128bit[i])
        );
    end

    // Final count for 255 bits (combining 128-bit counts and the remaining 7 bits)
    adder_9bit u_adder_9bit_1 (
       .a(count_128bit[0]),
       .b(count_128bit[1]),
       .out(count_256bit)
    );

    pop_count_7bit u_pop_count_7bit (
       .in(in[7:0]),
       .out()
    );

    assign out = count_256bit[7:0] + {8{in[0]}};

endmodule

module pop_count_8bit (
    input  [7:0] in,
    output [4:0] out
);

    assign out = {1'b0, in[7]} + {1'b0, in[6]} + {1'b0, in[5]} + {1'b0, in[4]} + {1'b0, in[3]} + {1'b0, in[2]} + {1'b0, in[1]} + {1'b0, in[0]};

endmodule

module pop_count_7bit (
    input  [6:0] in,
    output [3:0] out
);

    assign out = {1'b0, in[6]} + {1'b0, in[5]} + {1'b0, in[4]} + {1'b0, in[3]} + {1'b0, in[2]} + {1'b0, in[1]} + {1'b0, in[0]};

endmodule

module adder_5bit (
    input  [4:0] a,
    input  [4:0] b,
    output [5:0] out
);

    assign out = a + b;

endmodule

module adder_6bit (
    input  [5:0] a,
    input  [5:0] b,
    output [6:0] out
);

    assign out = a + b;

endmodule

module adder_7bit (
    input  [6:0] a,
    input  [6:0] b,
    output [7:0] out
);

    assign out = a + b;

endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    output [8:0] out
);

    assign out = a + b;

endmodule

module adder_9bit (
    input  [8:0] a,
    input  [8:0] b,
    output [9:0] out
);

    assign out = a + b;

endmodule