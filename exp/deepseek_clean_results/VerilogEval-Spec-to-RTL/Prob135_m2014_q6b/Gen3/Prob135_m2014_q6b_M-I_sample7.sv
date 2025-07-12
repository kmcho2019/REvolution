module TopModule (
    input clk,        // Clock input needed for sequential logic
    input reset,      // Reset input for initialization
    input [2:0] y,    // Current state (input)
    input w,          // Input signal
    output Y1         // Output y[1]
);

reg [2:0] next_state; // Next state value
reg [2:0] state_reg;  // State register

// State encoding parameters
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State register update
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= A;  // Reset to state A
    end else begin
        state_reg <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state_reg)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
        default: next_state = A;
    endcase
end

// Output assignment
assign Y1 = state_reg[1];

endmodule