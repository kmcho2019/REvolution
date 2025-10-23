module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    reg [5:0] current_state;

    // Next state logic using continuous assignments
    wire [5:0] next_state;
    assign next_state = reset ? A : 
        (current_state == A) ? (w ? A : B) :
        (current_state == B) ? (w ? D : C) :
        (current_state == C) ? (w ? D : E) :
        (current_state == D) ? (w ? A : F) :
        (current_state == E) ? (w ? D : E) :
        (current_state == F) ? (w ? D : C) :
        A;  // default to A

    // State register
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic - E or F states
    assign z = current_state[4] | current_state[5];

endmodule