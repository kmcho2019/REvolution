module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output reg done
);

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= 2'b00;
            done <= 1'b0;
        end else begin
            done <= (state == 2'b10);  // Assert done when completing message
            
            case (state)
                2'b00: state <= in[3] ? 2'b01 : 2'b00;  // Wait for start byte
                2'b01: state <= 2'b10;                  // Shift to second byte
                2'b10: state <= 2'b00;                  // Shift back to idle
                default: state <= 2'b00;               // Safety catch
            endcase
        end
    end

endmodule