module OptimizedTop(
    input x,
    input y,
    output reg z
);
    // State tracking for ModuleB behavior
    reg [1:0] prev_inputs;
    wire module_a_out = (x ^ y) & x;
    wire module_b_out;
    
    // State-aware ModuleB implementation
    always @(*) begin
        case(prev_inputs)
            2'b00: module_b_out = 1'b1;
            2'b01: module_b_out = 1'b0;
            2'b10: module_b_out = 1'b0;
            2'b11: module_b_out = 1'b1;
        endcase
    end
    
    // Output computation with state update
    always @(*) begin
        z = module_a_out ^ module_b_out;
        prev_inputs = {x,y};
    end
    
    // Initial state
    initial begin
        prev_inputs = 2'b00;
    end
endmodule