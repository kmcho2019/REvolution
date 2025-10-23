// Module for XOR gate with D flip-flop
module xor_dff(input clk, input x, input q, output reg z);
    reg q_next;
    assign z = x ^ q;
    always @(posedge clk) begin
        q_next = z;
    end
    assign q = q_next;
endmodule

// Module for AND gate with D flip-flop
module and_dff(input clk, input x, input q, output reg z);
    reg q_next;
    assign z = x & ~q;
    always @(posedge clk) begin
        q_next = z;
    end
    assign q = q_next;
endmodule

// Module for OR gate with D flip-flop
module or_dff(input clk, input x, input q, output reg z);
    reg q_next;
    assign z = x | ~q;
    always @(posedge clk) begin
        q_next = z;
    end
    assign q = q_next;
endmodule

// Top-level module
module TopModule(
    input clk,
    input x,
    output reg z
);
    reg xor_q = 0, and_q = 0, or_q = 0;
    wire xor_out, and_out, or_out;

    xor_dff xor_inst(clk, x, xor_q, xor_out);
    and_dff and_inst(clk, x, and_q, and_out);
    or_dff or_inst(clk, x, or_q, or_out);

    assign z = ~(xor_out | and_out | or_out);
endmodule