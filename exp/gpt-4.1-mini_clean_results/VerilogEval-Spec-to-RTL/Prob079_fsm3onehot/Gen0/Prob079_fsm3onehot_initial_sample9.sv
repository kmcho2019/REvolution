module TopModule (
    input  wire       in,
    input  wire [3:0] state,
    output reg  [3:0] next_state,
    output reg        out
);
    // State encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            A: begin
                // Output for A is 0
                out = 1'b0;
                // Next state depends on input
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = B;
            end
            B: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            C: begin
                out = 1'b0;
                if (in == 1'b0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                out = 1'b1;
                if (in == 1'b0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: begin
                // If invalid state, reset to A
                next_state = A;
                out = 1'b0;
            end
        endcase
    end

endmodule