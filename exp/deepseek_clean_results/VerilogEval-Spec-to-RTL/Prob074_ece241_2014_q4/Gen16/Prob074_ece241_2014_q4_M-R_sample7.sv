module TopModule (
    input clk,
    input x,
    output z
);

    // Wire declarations
    wire xor_out, and_out, or_out;
    wire xor_in, and_in, or_in;
    
    // XOR gate with feedback
    assign xor_in = x ^ xor_out;
    DFF xor_ff (.clk(clk), .d(xor_in), .q(xor_out));
    
    // AND gate with inverted feedback
    assign and_in = x & ~and_out;
    DFF and_ff (.clk(clk), .d(and_in), .q(and_out));
    
    // OR gate with inverted feedback
    assign or_in = x | ~or_out;
    DFF or_ff (.clk(clk), .d(or_in), .q(or_out));
    
    // Final NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule

// Synchronous D Flip-Flop with reset
module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule