module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding for states
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic using case statement on one-hot encoded state
    always @(*) begin
        case (state)
            A: begin
                if (w == 1'b0) next_state = B;
                else           next_state = A;
            end
            B: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            C: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            D: begin
                if (w == 1'b0) next_state = F;
                else           next_state = A;
            end
            E: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            F: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            default: next_state = A; // default to safe state
        endcase
    end

    // State register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic: z=1 if in state E or F
    always @(*) begin
        z = (state == E) || (state == F);
    end

endmodule