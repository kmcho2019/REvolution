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
            // Default done is 0 unless we're at state 2 (third byte)
            done <= (state == 2'b10);
            
            // State transition logic
            case (state)
                2'b00: state <= in[3] ? 2'b01 : 2'b00;  // Wait for start byte
                2'b01: state <= 2'b10;                   // Second byte
                2'b10: state <= 2'b00;                   // Third byte, return to idle
                default: state <= 2'b00;                 // Handle unexpected states
            endcase
        end
    end

endmodule