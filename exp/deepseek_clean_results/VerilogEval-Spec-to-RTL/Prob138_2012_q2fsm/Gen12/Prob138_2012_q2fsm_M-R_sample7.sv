module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    localparam [5:0] A = 6'b000001,
                     B = 6'b000010,
                     C = 6'b000100,
                     D = 6'b001000,
                     E = 6'b010000,
                     F = 6'b100000;

    reg [5:0] current_state;
    wire [5:0] next_state;

    // State transition logic using one-hot bit operations
    assign next_state = 
        (current_state == A) ? (w ? B : A) :
        (current_state == B) ? (w ? C : D) :
        (current_state == C) ? (w ? E : D) :
        (current_state == D) ? (w ? F : A) :
        (current_state == E) ? (w ? E : D) :
        (current_state == F) ? (w ? C : D) :
        A; // Default case

    // State storage with reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - OR of states where z=1 (E and F)
    assign z = current_state[4] | current_state[5];

endmodule