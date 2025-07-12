module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);
    // Define symbolic one-hot states for clarity
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    always @(*) begin
        // Default outputs
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            A: begin
                out = 1'b0;
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
                // If invalid state, force to A
                next_state = A;
                out = 1'b0;
            end
        endcase
    end
endmodule