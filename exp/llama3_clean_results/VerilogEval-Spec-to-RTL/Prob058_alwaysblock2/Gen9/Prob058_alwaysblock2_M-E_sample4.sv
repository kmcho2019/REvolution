module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Directly implement the XOR operation for out_assign
    assign out_assign = a ^ b;
    
    // Use a combinational logic (LUT approach) for out_always_comb
    assign out_always_comb = a ^ b;
    
    // Implement a simple FSM for out_always_ff
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end
    
    // Alternatively, for a more complex FSM approach:
    // reg [1:0] state;
    // always @(posedge clk) begin
    //     case(state)
    //         2'b00: out_always_ff <= a ^ b;
    //         default: out_always_ff <= out_always_ff;
    //     endcase
    // end
    
endmodule