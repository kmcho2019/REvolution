module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Modified one-hot encoding with output group bit
    // [0] = A, [1] = B, [2] = C, [3] = D, [4] = E, [5] = F
    // [6] = output group (0 for A/B/C/D, 1 for E/F)
    reg [6:0] current_state;

    // Parallel next state computation
    wire [6:0] next_A = w ? 7'b0000000 : 7'b0000010;  // A->A or A->B
    wire [6:0] next_B = w ? 7'b0001000 : 7'b0000100;  // B->D or B->C
    wire [6:0] next_C = w ? 7'b0001000 : 7'b0100000;  // C->D or C->E
    wire [6:0] next_D = w ? 7'b0000000 : 7'b1000000;  // D->A or D->F
    wire [6:0] next_E = w ? 7'b0001000 : 7'b0100000;  // E->D or E->E
    wire [6:0] next_F = w ? 7'b0001000 : 7'b0000100;  // F->D or F->C

    // Next state multiplexer
    wire [6:0] next_state = 
        (current_state[0] ? next_A :
         current_state[1] ? next_B :
         current_state[2] ? next_C :
         current_state[3] ? next_D :
         current_state[4] ? next_E :
         current_state[5] ? next_F : 7'b0) | 
        {1'b0, 6'b0, (current_state[4] | current_state[5])};  // Maintain output group bit

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= 7'b0000000;  // Reset to state A
        end else begin
            current_state <= next_state;
        end
    end

    // Output is directly from the output group bit
    assign z = current_state[6];

endmodule