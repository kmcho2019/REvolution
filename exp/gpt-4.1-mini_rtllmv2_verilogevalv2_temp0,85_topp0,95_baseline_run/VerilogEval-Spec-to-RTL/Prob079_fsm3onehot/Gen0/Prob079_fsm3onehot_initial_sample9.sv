module TopModule (
    input        in,
    input  [3:0] state,
    output [3:0] next_state,
    output       out
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    reg [3:0] next_state_reg;
    reg       out_reg;

    always @(*) begin
        case (state)
            A: begin
                out_reg = 1'b0;
                if (in == 1'b0)
                    next_state_reg = A;
                else
                    next_state_reg = B;
            end
            B: begin
                out_reg = 1'b0;
                if (in == 1'b0)
                    next_state_reg = C;
                else
                    next_state_reg = B;
            end
            C: begin
                out_reg = 1'b0;
                if (in == 1'b0)
                    next_state_reg = A;
                else
                    next_state_reg = D;
            end
            D: begin
                out_reg = 1'b1;
                if (in == 1'b0)
                    next_state_reg = C;
                else
                    next_state_reg = B;
            end
            default: begin
                // Default to state A and output 0 if invalid state
                next_state_reg = A;
                out_reg = 1'b0;
            end
        endcase
    end

    assign next_state = next_state_reg;
    assign out = out_reg;

endmodule