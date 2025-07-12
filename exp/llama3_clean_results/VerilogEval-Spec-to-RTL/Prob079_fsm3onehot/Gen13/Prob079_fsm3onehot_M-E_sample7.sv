module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Parameterized state encoding
    localparam NUM_STATES = 4;
    localparam STATE_WIDTH = $clog2(NUM_STATES);
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // State transition logic and output logic using a case statement
    always @(*) begin
        case (state)
            A: begin
                if (!in) next_state = A;
                else next_state = B;
                out = 1'b0;
            end
            B: begin
                if (!in) next_state = C;
                else next_state = B;
                out = 1'b0;
            end
            C: begin
                if (!in) next_state = A;
                else next_state = D;
                out = 1'b0;
            end
            D: begin
                if (!in) next_state = C;
                else next_state = B;
                out = 1'b1;
            end
            default: begin
                next_state = 4'bxxxx;
                out = 1'b0;
            end
        endcase
    end

endmodule