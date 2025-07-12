module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // State encoding remains the same
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;

    // State transition as parallel assignments
    assign next_state[0] = (current_state == A) ? w :
                          (current_state == B) ? w :
                          (current_state == C) ? 1'b0 :
                          (current_state == D) ? ~w :
                          (current_state == E) ? 1'b0 :
                          (current_state == F) ? w : 1'b0;

    assign next_state[1] = (current_state == A) ? 1'b0 :
                          (current_state == B) ? w :
                          (current_state == C) ? w :
                          (current_state == D) ? w :
                          (current_state == E) ? ~w :
                          (current_state == F) ? 1'b1 : 1'b0;

    assign next_state[2] = (current_state == A) ? 1'b0 :
                          (current_state == B) ? 1'b0 :
                          (current_state == C) ? w :
                          (current_state == D) ? w :
                          (current_state == E) ? 1'b1 :
                          (current_state == F) ? 1'b1 : 1'b0;

    // State storage (sequential)
    always @(posedge clk)
        current_state <= reset ? A : next_state;

    // Output logic remains the same
    assign z = current_state[2];

endmodule