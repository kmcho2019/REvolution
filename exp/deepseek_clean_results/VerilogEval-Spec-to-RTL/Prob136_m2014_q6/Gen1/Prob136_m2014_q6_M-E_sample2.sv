module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    reg [5:0] current_state, next_state;
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    // State transition logic (sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        next_state = 6'b0;  // Default to avoid latches
        case (1'b1)  // Synthesis will recognize this as priority encoder
            current_state[A]: next_state = w ? A : B;
            current_state[B]: next_state = w ? D : C;
            current_state[C]: next_state = w ? D : E;
            current_state[D]: next_state = w ? A : F;
            current_state[E]: next_state = w ? D : E;
            current_state[F]: next_state = w ? D : C;
            default: next_state = A;
        endcase
    end

    // Output logic - simply check if in state E or F
    assign z = current_state[E] | current_state[F];

endmodule