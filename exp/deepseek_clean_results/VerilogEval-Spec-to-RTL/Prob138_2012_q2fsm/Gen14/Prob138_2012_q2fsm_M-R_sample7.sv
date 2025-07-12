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

    // Next state logic using bitwise operations
    wire [5:0] next_state = 
        ({6{current_state == A}} & (w ? B : A)) |
        ({6{current_state == B}} & (w ? C : D)) |
        ({6{current_state == C}} & (w ? E : D)) |
        ({6{current_state == D}} & (w ? F : A)) |
        ({6{current_state == E}} & (w ? E : D)) |
        ({6{current_state == F}} & (w ? C : D));

    // State storage with inline reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Output logic - E or F states set z high
    assign z = current_state[4] | current_state[5];

endmodule