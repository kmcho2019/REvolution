module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output reg [23:0] out_bytes,
    output reg done
);

// Use a one-hot encoding scheme for the state register
reg [2:0] state;

// Initialize state to idle (001) on reset
always @(posedge clk) begin
    if (reset) begin
        state <= 3'b001;
        out_bytes <= 24'b0;
        done <= 1'b0;
    end else begin
        case (state)
            3'b001: begin // Idle state
                if (in[3] == 1'b1) begin
                    out_bytes[23:16] <= in;
                    state <= 3'b010; // Transition to byte1 state
                end else begin
                    state <= 3'b001; // Stay in idle state
                end
                done <= 1'b0;
            end
            3'b010: begin // Byte1 state
                out_bytes[15:8] <= in;
                state <= 3'b100; // Transition to byte2 state
                done <= 1'b0;
            end
            3'b100: begin // Byte2 state
                out_bytes[7:0] <= in;
                state <= 3'b001; // Transition back to idle state
                done <= 1'b1; // Signal done
            end
            default: begin
                state <= 3'b001; // Reset to idle state
                done <= 1'b0;
            end
        endcase
    end
end

endmodule