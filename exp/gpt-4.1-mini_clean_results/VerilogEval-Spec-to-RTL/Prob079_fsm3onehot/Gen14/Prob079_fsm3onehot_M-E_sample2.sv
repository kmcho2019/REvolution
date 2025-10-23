module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // Define one-hot states for clarity
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        // Default next_state to zero to avoid latches
        next_state = 4'b0000;
        case (state)
            A: begin
                if (in == 1'b0)
                    next_state = A; // stay in A
                else
                    next_state = B; // go to B
            end
            B: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: begin
                // Should not happen in one-hot FSM; safe default
                next_state = A;
            end
        endcase
    end

    // Moore output depends on current state only
    always @(*) begin
        case (state)
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

endmodule