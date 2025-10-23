module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

reg [1:0] state; // 2-bit state variable
reg [7:0] byte1, byte2, byte3; // Registers to store incoming bytes
reg [23:0] out_bytes_reg; // Register to store out_bytes

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00; // Reset state to WAITING
        out_bytes_reg <= 24'b0; // Reset out_bytes
    end else begin
        case (state)
            2'b00: begin // WAITING
                if (in[3] == 1'b1) begin
                    byte1 <= in;
                    state <= 2'b01; // Move to RECEIVING_BYTE2
                end
            end
            2'b01: begin // RECEIVING_BYTE2
                byte2 <= in;
                state <= 2'b10; // Move to RECEIVING_BYTE3
            end
            2'b10: begin // RECEIVING_BYTE3
                byte3 <= in;
                state <= 2'b00; // Move back to WAITING
                out_bytes_reg <= {byte1, byte2, byte3}; // Store out_bytes
            end
            default: begin // DONE
                state <= 2'b00; // Move back to WAITING
            end
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else begin
        case (state)
            2'b10: begin // RECEIVING_BYTE3
                done <= 1'b1; // Signal done
            end
            default: begin
                done <= 1'b0;
            end
        endcase
    end
end

assign out_bytes = (state == 2'b10) ? out_bytes_reg : 24'b0;
endmodule