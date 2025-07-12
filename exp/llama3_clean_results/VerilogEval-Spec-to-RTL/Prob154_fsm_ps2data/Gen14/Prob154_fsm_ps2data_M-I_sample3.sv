module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Use a 2-bit state register to minimize area
reg [1:0] state;
reg [7:0] byte1, byte2;

// Initialize state to idle (00) on reset
always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        out_bytes <= 24'b0;
        done <= 1'b0;
        byte1 <= 8'b0;
        byte2 <= 8'b0;
    end else begin
        case (state)
            2'b00: begin // Idle state
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // Transition to byte1 state
                end else begin
                    state <= 2'b00; // Stay in idle state
                end
                done <= 1'b0;
            end
            2'b01: begin // Byte1 state
                byte2 <= in;
                out_bytes[23:16] <= byte1;
                out_bytes[15:8] <= in;
                state <= 2'b10; // Transition to byte2 state
                done <= 1'b0;
            end
            2'b10: begin // Byte2 state
                out_bytes[7:0] <= in;
                state <= 2'b00; // Transition back to idle state
                done <= 1'b1; // Signal done
            end
            default: begin
                state <= 2'b00; // Reset to idle state
                done <= 1'b0;
            end
        endcase
    end
end

endmodule