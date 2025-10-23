module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    reg [1:0] state; // Finite State Machine state variable
    reg xor_result;  // XOR gate result

    // XOR gate implementation
    assign xor_result = a ^ b;

    // Finite State Machine logic
    always @(posedge clk) begin
        case(state)
            2'b00: begin // State 0: Assign XOR result to out_assign
                out_assign <= xor_result;
                state <= 2'b01;
            end
            2'b01: begin // State 1: Assign XOR result to out_always_comb
                out_always_comb <= xor_result;
                state <= 2'b10;
            end
            2'b10: begin // State 2: Update out_always_ff with XOR result
                out_always_ff <= xor_result;
                state <= 2'b00; // Reset state back to 0
            end
            default: state <= 2'b00; // Default case to handle any unexpected state
        endcase
    end

endmodule