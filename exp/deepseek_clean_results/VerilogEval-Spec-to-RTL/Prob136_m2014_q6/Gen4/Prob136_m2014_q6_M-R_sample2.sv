module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot state encoding
    parameter A = 6'b000001;
    parameter B = 6'b000010;
    parameter C = 6'b000100;
    parameter D = 6'b001000;
    parameter E = 6'b010000;
    parameter F = 6'b100000;

    reg [5:0] current_state, next_state;

    // Continuous assignments for next state logic
    assign next_state = 
        (current_state == A) ? (w ? A : B) :
        (current_state == B) ? (w ? D : C) :
        (current_state == C) ? (w ? D : E) :
        (current_state == D) ? (w ? A : F) :
        (current_state == E) ? (w ? D : E) :
        (current_state == F) ? (w ? D : C) :
        A;  // Default to A

    // State register with registered output
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            z <= (next_state == E) | (next_state == F);
        end
    end

endmodule