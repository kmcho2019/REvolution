// Define a module for a 2-input XOR gate
module xor_gate(
    input a,
    input b,
    output z
);
    assign z = a ^ b;
endmodule

// Define a module for a 2-input AND gate
module and_gate(
    input a,
    input b,
    output z
);
    assign z = a & b;
endmodule

// Define a module for a 2-input OR gate
module or_gate(
    input a,
    input b,
    output z
);
    assign z = a | b;
endmodule

// Define a module for a D flip-flop
module d_flip_flop(
    input clk,
    input reset,
    input d,
    output q
);
    reg q_reg;
    assign q = q_reg;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg <= 0;
        end else begin
            q_reg <= d;
        end
    end
endmodule

// Define the TopModule
module TopModule(
    input clk,
    input x,
    output z
);
    wire xor_out, and_out, or_out;
    wire q_xor, q_and, q_or;
    
    // Instantiate the gates
    xor_gate u_xor(x, q_xor, xor_out);
    and_gate u_and(x, ~q_and, and_out);
    or_gate u_or(x, ~q_or, or_out);
    
    // Instantiate the D flip-flops
    d_flip_flop u_dff_xor(clk, 1'b0, xor_out, q_xor);
    d_flip_flop u_dff_and(clk, 1'b0, and_out, q_and);
    d_flip_flop u_dff_or(clk, 1'b0, or_out, q_or);
    
    // Compute the output z of the NOR gate
    assign z = ~(xor_out | and_out | or_out);
endmodule