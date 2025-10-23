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

    reg [2:0] current_state;
    wire [2:0] next_state;

    // Parallel state transition logic using ternary operators
    assign next_state = (current_state == A) ? (w ? B : A) :
                       (current_state == B) ? (w ? C : D) :
                       (current_state == C) ? (w ? E : D) :
                       (current_state == D) ? (w ? F : A) :
                       (current_state == E) ? (w ? E : D) :
                       (current_state == F) ? (w ? C : D) :
                       A;  // default case

    // Combined state storage and reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output remains the same - simple bit check
    assign z = current_state[2];

endmodule