module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b00;
            done <= 1'b0;
        end else begin
            // Optimized done signal generation
            done <= &cnt;  // Equivalent to (cnt == 2'b11) but with bitwise AND
            
            case (cnt)
                2'b00: if (in[3]) cnt <= 2'b01;  // Start new message
                2'b01: cnt <= 2'b10;             // Second byte
                2'b10: cnt <= 2'b00;             // Third byte - wrap around
                default: cnt <= 2'b00;           // Safety net
            endcase
        end
    end

endmodule