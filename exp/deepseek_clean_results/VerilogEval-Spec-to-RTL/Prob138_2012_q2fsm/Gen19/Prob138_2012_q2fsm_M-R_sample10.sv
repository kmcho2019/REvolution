module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding remains the same
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b100;

    reg [2:0] current_state, next_state;

    // State transition logic using parallel ternary operators
    always @(*) begin
        next_state = (current_state == A) ? (w ? B : A) :
                    (current_state == B) ? (w ? C : D) :
                    (current_state == C) ? (w ? E : D) :
                    (current_state == D) ? (w ? F : A) :
                    (current_state == E) ? (w ? E : D) :
                    (current_state == F) ? (w ? C : D) : A;
    end

    // State storage with reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
        z <= current_state[2];  // Output logic in same always block
    end

endmodule