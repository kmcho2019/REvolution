module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right with taps XORed with feedback
            q[0] <= feedback; // LSB gets the feedback bit
            for (i = 1; i < 32; i = i + 1) begin
                case (i)
                    1, 21, 31: // taps at bits 2, 22, 32 (indexing from 0)
                        q[i] <= q[i-1] ^ feedback;
                    default:
                        q[i] <= q[i-1];
                endcase
            end
        end
    end

endmodule