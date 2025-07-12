module TopModule (
    input clk,
    input x,
    output z
);

    // Individual flip-flop outputs
    wire xor_out, and_out, or_out;
    
    // XOR path with direct feedback
    dff_with_feedback #(.GATE_TYPE(0)) xor_path (
        .clk(clk),
        .x(x),
        .q(xor_out)
    );
    
    // AND path with complemented feedback
    dff_with_feedback #(.GATE_TYPE(1)) and_path (
        .clk(clk),
        .x(x),
        .q(and_out)
    );
    
    // OR path with complemented feedback
    dff_with_feedback #(.GATE_TYPE(2)) or_path (
        .clk(clk),
        .x(x),
        .q(or_out)
    );
    
    // Final NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule

// Parameterized submodule for all three cases
module dff_with_feedback #(
    parameter GATE_TYPE = 0 // 0:XOR, 1:AND, 2:OR
) (
    input clk,
    input x,
    output reg q
);
    wire feedback;
    wire gate_out;
    
    // Select feedback based on gate type
    assign feedback = (GATE_TYPE == 0) ? q : ~q;
    
    // Gate implementation
    assign gate_out = (GATE_TYPE == 0) ? x ^ feedback :
                     (GATE_TYPE == 1) ? x & feedback :
                                        x | feedback;
    
    // D flip-flop
    always @(posedge clk) begin
        q <= gate_out;
    end
    
    // Initialize to 0 (simulation)
    initial q = 1'b0;
endmodule