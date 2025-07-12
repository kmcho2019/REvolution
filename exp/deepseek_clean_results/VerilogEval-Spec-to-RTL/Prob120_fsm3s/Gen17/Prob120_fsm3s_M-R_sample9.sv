module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding parameters
    parameter [1:0] A = 2'b00;
    parameter [1:0] B = 2'b01;
    parameter [1:0] C = 2'b10;
    parameter [1:0] D = 2'b11;

    // State registers
    reg [1:0] current_state, next_state;

    // Next state combinational logic
    assign next_state = (reset) ? A :  // Reset condition
                       (current_state == A) ? (in ? B : A) :  // State A transitions
                       (current_state == B) ? (in ? B : C) :  // State B transitions
                       (current_state == C) ? (in ? D : A) :  // State C transitions
                       (current_state == D) ? (in ? B : C) :  // State D transitions
                       A;  // Default case (should never occur)

    // State register update (sequential logic)
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic (combinational)
    assign out = (current_state == D);

endmodule