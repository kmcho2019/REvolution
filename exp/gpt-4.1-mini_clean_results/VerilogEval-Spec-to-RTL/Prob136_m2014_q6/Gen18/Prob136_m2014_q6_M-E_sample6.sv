module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // One-hot encoding of states
    localparam [5:0]
        A = 6'b000001,
        B = 6'b000010,
        C = 6'b000100,
        D = 6'b001000,
        E = 6'b010000,
        F = 6'b100000;

    reg [5:0] state, next_state;

    // Next state logic combinational block
    always @(*) begin
        case (1'b1)
            state[A]: begin
                if (w == 1'b0) next_state = B;
                else           next_state = A;
            end
            state[B]: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            state[C]: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[D]: begin
                if (w == 1'b0) next_state = F;
                else           next_state = A;
            end
            state[E]: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
            end
            state[F]: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset) 
            state <= A;
        else 
            state <= next_state;
    end

    // Output logic: z is 1 when in state E or F
    always @(*) begin
        z = (state[E] || state[F]) ? 1'b1 : 1'b0;
    end

endmodule