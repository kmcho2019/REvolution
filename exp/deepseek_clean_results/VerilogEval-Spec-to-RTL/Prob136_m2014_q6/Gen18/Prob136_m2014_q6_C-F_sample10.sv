module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire w,
    output wire z
);

    // Gray-coded state encoding with descriptive names
    localparam [2:0] 
        STATE_A = 3'b000,
        STATE_B = 3'b001,
        STATE_C = 3'b011,
        STATE_D = 3'b010,
        STATE_E = 3'b110,
        STATE_F = 3'b100;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State transition logic with comments
    always @(*) begin
        case (current_state)
            STATE_A: next_state = w ? STATE_A : STATE_B;  // A stays on 1, goes to B on 0
            STATE_B: next_state = w ? STATE_D : STATE_C;  // B to D on 1, to C on 0
            STATE_C: next_state = w ? STATE_D : STATE_E;  // C to D on 1, to E on 0
            STATE_D: next_state = w ? STATE_A : STATE_F;  // D to A on 1, to F on 0
            STATE_E: next_state = w ? STATE_D : STATE_E;  // E stays on 0, to D on 1
            STATE_F: next_state = w ? STATE_D : STATE_C;  // F to C on 0, to D on 1
            default:  next_state = STATE_A;               // Safe default
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= STATE_A;
        else
            current_state <= next_state;
    end

    // Output is high for states E and F (MSB=1)
    assign z = current_state[2];

    // Synthesis pragmas for optimization
    /* synthesis parallel_case */
    /* synthesis full_case */

endmodule