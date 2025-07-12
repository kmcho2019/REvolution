// Sub-module for XOR gate with D flip-flop
module XorDFF(
    input clk,
    input x,
    output y
);
    reg state = 0;
    assign y = state;
    always @(posedge clk) begin
        state <= x ^ state;
    end
endmodule

// Sub-module for AND gate with D flip-flop
module AndDFF(
    input clk,
    input x,
    output y
);
    reg state = 0;
    assign y = state;
    always @(posedge clk) begin
        state <= x & ~state;
    end
endmodule

// Sub-module for OR gate with D flip-flop
module OrDFF(
    input clk,
    input x,
    output y
);
    reg state = 0;
    assign y = state;
    always @(posedge clk) begin
        state <= x | ~state;
    end
endmodule

// TopModule using sub-modules
module TopModule(
    input clk,
    input x,
    output z
);
    wire xor_out, and_out, or_out;
    
    // Instantiate sub-modules for each gate type
    XorDFF xor_dff(clk, x, xor_out);
    AndDFF and_dff(clk, x, and_out);
    OrDFF or_dff(clk, x, or_out);
    
    // Calculate output z as the NOR of the sub-module outputs
    assign z = ~(xor_out | and_out | or_out);
endmodule