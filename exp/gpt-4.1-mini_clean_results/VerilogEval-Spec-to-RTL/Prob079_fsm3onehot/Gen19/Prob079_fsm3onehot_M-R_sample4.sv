module TopModule (
    input  wire       in,
    input  wire [3:0] state,
    output reg  [3:0] next_state,
    output reg        out
);

    always @* begin
        next_state = 4'b0000; // default
        out = 1'b0;           // default

        casez (state)
            4'b0001: begin // A
                out = 1'b0;
                next_state = (in == 1'b0) ? 4'b0001 : 4'b0010; // A or B
            end
            4'b0010: begin // B
                out = 1'b0;
                next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // C or B
            end
            4'b0100: begin // C
                out = 1'b0;
                next_state = (in == 1'b0) ? 4'b0001 : 4'b1000; // A or D
            end
            4'b1000: begin // D
                out = 1'b1;
                next_state = (in == 1'b0) ? 4'b0100 : 4'b0010; // C or B
            end
            default: begin
                out = 1'b0;
                next_state = 4'b0001; // default to A if invalid state
            end
        endcase
    end

endmodule