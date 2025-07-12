module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

    // One-hot encoding for states: Each state is a single bit set
    localparam A = 6'b000001;
    localparam B = 6'b000010;
    localparam C = 6'b000100;
    localparam D = 6'b001000;
    localparam E = 6'b010000;
    localparam F = 6'b100000;

    reg [5:0] state, next_state;

    // State flip-flops
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state combinational logic
    always @(*) begin
        // Default: no states active
        next_state = 6'b000000;

        case (1'b1)  // priority encoding to find current state
            state[0]: begin // A
                if (w == 1'b0) next_state = B;
                else           next_state = A;
            end
            state[1]: begin // B
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            state[2]: begin // C
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[3]: begin // D
                if (w == 1'b0) next_state = F;
                else           next_state = A;
            end
            state[4]: begin // E
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[5]: begin // F
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            default: next_state = A; // Fallback on invalid state
        endcase
    end

    // Output logic: z = 1 when in E or F
    assign z = state[4] | state[5];

endmodule