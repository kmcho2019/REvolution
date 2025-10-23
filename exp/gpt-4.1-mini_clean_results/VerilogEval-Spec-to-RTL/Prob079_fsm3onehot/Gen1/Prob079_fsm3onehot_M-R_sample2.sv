module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    // State encoding: A=4'b0001, B=4'b0010, C=4'b0100, D=4'b1000

    always @(*) begin
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
            4'b0001: begin // A
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0001; // A
                out = 1'b0;
            end

            4'b0010: begin // B
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
                out = 1'b0;
            end

            4'b0100: begin // C
                if (in)
                    next_state = 4'b1000; // D
                else
                    next_state = 4'b0001; // A
                out = 1'b0;
            end

            4'b1000: begin // D
                if (in)
                    next_state = 4'b0010; // B
                else
                    next_state = 4'b0100; // C
                out = 1'b1;
            end

            default: begin
                next_state = 4'b0001; // Default to A
                out = 1'b0;
            end
        endcase
    end

endmodule