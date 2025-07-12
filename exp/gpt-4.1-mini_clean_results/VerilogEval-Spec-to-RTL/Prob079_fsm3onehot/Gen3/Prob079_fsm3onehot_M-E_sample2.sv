module TopModule (
    input        in,
    input  [3:0] state,
    output reg [3:0] next_state,
    output reg       out
);

    always @(*) begin
        // Default assignments
        next_state = 4'b0000;
        out = 1'b0;

        case (state)
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
                // In case of invalid encoding, default to state A and out=0
                next_state = 4'b0001;
                out = 1'b0;
            end
        endcase
    end

endmodule