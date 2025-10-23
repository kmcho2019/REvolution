module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state representation
    reg [5:0] state;
    wire [5:0] next_state;

    // State definitions (one-hot positions)
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // Next state logic (shift operations)
    assign next_state = 
        (state == A) ? (w ? A : B) :
        (state == B) ? (w ? D : C) :
        (state == C) ? (w ? D : E) :
        (state == D) ? (w ? A : F) :
        (state == E) ? (w ? D : E) :
        (state == F) ? (w ? D : C) :
        6'b000000;  // Default case (should never occur)

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Output logic (E or F states produce z=1)
    assign z = state[4] | state[5];  // Bits 4 and 5 are E and F

endmodule