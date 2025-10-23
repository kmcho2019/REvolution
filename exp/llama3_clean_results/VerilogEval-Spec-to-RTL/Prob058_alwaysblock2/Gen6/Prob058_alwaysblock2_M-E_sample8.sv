// TopModule implementation
module TopModule(
    input clk,
    input a,
    input b,
    input mode, // mode selection input: 0 - assign, 1 - combinational always block, 2 - clocked always block
    input clk_enable, // clock enable signal
    output out_assign,
    output out_always_comb,
    output out_always_ff
);
    
    // Shared XOR gate circuit
    wire xor_out;
    assign xor_out = a ^ b;
    
    // Assign statement for out_assign
    assign out_assign = xor_out;
    
    // Combinational always block for out_always_comb
    reg out_comb;
    always_comb begin
        out_comb = xor_out;
    end
    assign out_always_comb = out_comb;
    
    // Clocked always block for out_always_ff
    reg out_ff;
    always_ff @(posedge clk) begin
        if (clk_enable) begin
            out_ff <= xor_out;
        end
    end
    assign out_always_ff = out_ff;
    
    // 2:1 multiplexer to select between outputs
    wire selected_out;
    always_comb begin
        case (mode)
            1'b0: selected_out = out_assign;
            1'b1: selected_out = out_always_comb;
            default: selected_out = out_always_ff;
        endcase
    end
    
    // Optional: output the selected output
    // assign final_out = selected_out;
    
endmodule