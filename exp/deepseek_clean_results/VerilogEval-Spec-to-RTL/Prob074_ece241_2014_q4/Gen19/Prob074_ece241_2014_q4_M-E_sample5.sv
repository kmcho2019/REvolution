module TopModule (
    input clk,
    input x,
    output z
);

    // Instantiate three gate-flipflop modules
    wire xor_out, and_out, or_out;
    
    GateFFPair XOR_FF (
        .clk(clk),
        .x(x),
        .feedback(xor_out),
        .feedback_pol(1'b0),  // 0 = direct feedback
        .out(xor_out)
    );
    
    GateFFPair AND_FF (
        .clk(clk),
        .x(x),
        .feedback(and_out),
        .feedback_pol(1'b1),  // 1 = complemented feedback
        .out(and_out)
    );
    
    GateFFPair OR_FF (
        .clk(clk),
        .x(x),
        .feedback(or_out),
        .feedback_pol(1'b1),  // 1 = complemented feedback
        .out(or_out)
    );
    
    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule

// Parameterized gate-flipflop pair module
module GateFFPair (
    input clk,
    input x,
    input feedback,
    input feedback_pol,  // 0=direct, 1=complemented
    output reg out
);
    reg gate_out;
    
    always @(*) begin
        case (feedback_pol)
            1'b0: gate_out = x ^ feedback;      // XOR with direct feedback
            1'b1: gate_out = x & ~feedback;     // AND with complemented feedback
            default: gate_out = x | ~feedback;   // OR with complemented feedback
        endcase
    end
    
    always @(posedge clk) begin
        out <= gate_out;
    end
    
    initial out = 1'b0;  // Explicit initialization
endmodule