module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Shift register implementation (3 bits)
    reg [2:0] state_reg;

    // State patterns:
    // A = 001, B = 010, C = 100, D = 110
    // Output is high when MSB is 1 and middle bit is 1 (state D)

    // Next state logic through shifting
    wire [2:0] next_state;
    assign next_state = reset ? 3'b001 : 
                      (state_reg == 3'b001) ? (in ? 3'b010 : 3'b001) : // A->B or A->A
                      (state_reg == 3'b010) ? (in ? 3'b010 : {state_reg[1:0], 1'b0}) : // B->B or B->C
                      (state_reg == 3'b100) ? (in ? {state_reg[1:0], 1'b1} : 3'b001) : // C->D or C->A
                      (in ? 3'b010 : {state_reg[1:0], 1'b0}); // D->B or D->C

    // State register update
    always @(posedge clk) begin
        state_reg <= next_state;
    end

    // Output logic - detect state D (110)
    assign out = (state_reg == 3'b110);

endmodule