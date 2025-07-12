module TopModule (
    input  in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg out
);
    always @* begin
        // Default assignments to avoid latches
        next_state = 4'b0000;
        out = 1'b0;

        casez (state)
            4'b0001: begin // A
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b0010; // B
            end
            4'b0010: begin // B
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B
            end
            4'b0100: begin // C
                out = 1'b0;
                if (in == 1'b0)
                    next_state = 4'b0001; // A
                else
                    next_state = 4'b1000; // D
            end
            4'b1000: begin // D
                out = 1'b1;
                if (in == 1'b0)
                    next_state = 4'b0100; // C
                else
                    next_state = 4'b0010; // B
            end
            default: begin
                // In case of invalid state, go to A and output 0
                next_state = 4'b0001;
                out = 1'b0;
            end
        endcase
    end
endmodule