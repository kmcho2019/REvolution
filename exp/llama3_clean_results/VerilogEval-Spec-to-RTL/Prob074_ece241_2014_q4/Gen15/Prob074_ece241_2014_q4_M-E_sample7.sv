// Define a module for each gate type connected to a D flip-flop
module xor_ff(
    input clk,
    input x,
    output q
);
    reg q_reg = 0;
    wire xor_out;
    assign xor_out = x ^ q_reg;
    always @(posedge clk) begin
        q_reg <= xor_out;
    end
    assign q = q_reg;
endmodule

module and_ff(
    input clk,
    input x,
    output q
);
    reg q_reg = 0;
    wire and_out;
    assign and_out = x & ~q_reg;
    always @(posedge clk) begin
        q_reg <= and_out;
    end
    assign q = q_reg;
endmodule

module or_ff(
    input clk,
    input x,
    output q
);
    reg q_reg = 0;
    wire or_out;
    assign or_out = x | ~q_reg;
    always @(posedge clk) begin
        q_reg <= or_out;
    end
    assign q = q_reg;
endmodule

// Top-level module
module TopModule(
    input clk,
    input x,
    output z
);
    wire xor_out, and_out, or_out;
    xor_ff u_xor_ff(clk, x, xor_out);
    and_ff u_and_ff(clk, x, and_out);
    or_ff u_or_ff(clk, x, or_out);
    
    // Calculate output z as the NOR of the registered states
    assign z = ~(xor_out | and_out | or_out);
endmodule