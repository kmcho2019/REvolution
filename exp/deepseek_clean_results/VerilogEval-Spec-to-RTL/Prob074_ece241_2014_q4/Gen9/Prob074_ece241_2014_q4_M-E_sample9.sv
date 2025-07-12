module TopModule (
    input clk,
    input x,
    output z
);

    // Define a submodule for each gate-flipflop pair
    module gate_ff_pair #(
        parameter GATE_TYPE = 0  // 0:XOR, 1:AND, 2:OR
    ) (
        input clk,
        input x,
        input feedback,
        output reg q
    );
        wire gate_out;
        
        always @(posedge clk) begin
            q <= gate_out;
        end
        
        // Gate implementations
        assign gate_out = 
            (GATE_TYPE == 0) ? x ^ feedback :
            (GATE_TYPE == 1) ? x & ~feedback :
            x | ~feedback;
    endmodule

    // Instantiate the three gate-flipflop pairs
    wire xor_out, and_out, or_out;
    
    gate_ff_pair #(.GATE_TYPE(0)) xor_unit (
        .clk(clk),
        .x(x),
        .feedback(xor_out),
        .q(xor_out)
    );
    
    gate_ff_pair #(.GATE_TYPE(1)) and_unit (
        .clk(clk),
        .x(x),
        .feedback(and_out),
        .q(and_out)
    );
    
    gate_ff_pair #(.GATE_TYPE(2)) or_unit (
        .clk(clk),
        .x(x),
        .feedback(or_out),
        .q(or_out)
    );

    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule