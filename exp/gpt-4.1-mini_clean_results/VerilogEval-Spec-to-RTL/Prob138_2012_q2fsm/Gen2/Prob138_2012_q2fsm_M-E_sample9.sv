module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot state encoding
    // States: A=000001, B=000010, C=000100, D=001000, E=010000, F=100000
    reg [5:0] current_state, next_state;

    // State flip-flops with synchronous reset
    always @(posedge clk) begin
        if (reset)
            current_state <= 6'b000001; // A state
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        // default: clear all next states
        next_state = 6'b000000;

        case (1'b1)
            current_state[0]: // A
                next_state = w ? 6'b000010 : 6'b000001; // B or A
            current_state[1]: // B
                next_state = w ? 6'b000100 : 6'b001000; // C or D
            current_state[2]: // C
                next_state = w ? 6'b010000 : 6'b001000; // E or D
            current_state[3]: // D
                next_state = w ? 6'b100000 : 6'b000001; // F or A
            current_state[4]: // E
                next_state = w ? 6'b010000 : 6'b001000; // E or D
            current_state[5]: // F
                next_state = w ? 6'b000100 : 6'b001000; // C or D
            default:
                next_state = 6'b000001; // Reset to A if invalid state
        endcase
    end

    // Output logic (Moore output)
    assign z = current_state[4] | current_state[5]; // E or F

endmodule