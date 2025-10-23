module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] cnt;

    always @(posedge clk) begin
        if (reset) begin
            cnt <= 2'b0;
            done <= 1'b0;
        end else begin
            done <= (cnt == 2'b10);  // Assert done when third byte is received
            
            case (cnt)
                2'b00: cnt <= in[3] ? 2'b01 : 2'b00;  // Wait for start byte
                2'b10: cnt <= 2'b00;                  // Reset after third byte
                default: cnt <= cnt + 1'b1;            // Increment for other cases
            endcase
        end
    end

endmodule