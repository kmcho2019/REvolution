module TopModule(
    input  clk,
    input  reset,
    input  [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // Current state
reg [7:0] byte1; // First byte of the message
reg [7:0] byte2; // Second byte of the message
reg [7:0] byte3; // Third byte of the message

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset to IDLE state
        done <= 0;
    end else begin
        case (state)
            2'b00: begin // IDLE
                if (in[3]) begin
                    byte1 <= in; // Store the first byte
                    state <= 2'b01; // Transition to BYTE1
                end
            end
            2'b01: begin // BYTE1
                byte2 <= in; // Store the second byte
                state <= 2'b10; // Transition to BYTE2
            end
            2'b10: begin // BYTE2
                byte3 <= in; // Store the third byte
                state <= 2'b11; // Transition to DONE
            end
            2'b11: begin // DONE
                out_bytes <= {byte1, byte2, byte3}; // Output the 24-bit message
                done <= 1;
                state <= 2'b00; // Transition back to IDLE
            end
        endcase
    end
end

endmodule