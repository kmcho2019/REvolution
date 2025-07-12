module ring_counter (
    input clk,
    input reset,
    output reg [7:0] out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001;
        end else begin
            if (out == 8'b10000000)
                out <= 8'b00000001;       // wrap around to LSB
            else begin
                // find which bit is set and shift it left by 1 without concatenation
                case (out)
                    8'b00000001: out <= 8'b00000010;
                    8'b00000010: out <= 8'b00000100;
                    8'b00000100: out <= 8'b00001000;
                    8'b00001000: out <= 8'b00010000;
                    8'b00010000: out <= 8'b00100000;
                    8'b00100000: out <= 8'b01000000;
                    8'b01000000: out <= 8'b10000000;
                    default:     out <= 8'b00000001; // safe fallback
                endcase
            end
        end
    end

endmodule