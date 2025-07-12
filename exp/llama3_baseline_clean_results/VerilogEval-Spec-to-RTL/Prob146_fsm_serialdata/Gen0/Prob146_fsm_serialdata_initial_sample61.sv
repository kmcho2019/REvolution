module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state;
reg [7:0] byte;
reg [2:0] bit_count;

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Idle state
        done <= 1'b0;
        out_byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        case (state)
            3'b000: begin // Idle state
                if (~in) begin // Start bit detected
                    state <= 3'b001; // Start state
                    byte <= 8'b0;
                    bit_count <= 3'b0;
                end
            end
            3'b001: begin // Start state
                state <= 3'b010; // Data state
            end
            3'b010: begin // Data state
                byte <= {byte[6:0], in}; // Shift in the data bit
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin // 8 data bits received
                    state <= 3'b011; // Stop state
                end
            end
            3'b011: begin // Stop state
                if (in) begin // Stop bit correct
                    out_byte <= byte;
                    done <= 1'b1;
                    state <= 3'b000; // Idle state
                end else begin // Stop bit incorrect, wait for stop bit
                    state <= 3'b100; // Wait state
                end
            end
            3'b100: begin // Wait state
                if (in) begin // Stop bit detected
                    state <= 3'b000; // Idle state
                end
            end
            default: begin
                state <= 3'b000; // Idle state
            end
        endcase
        if (state != 3'b011) begin // Reset done signal
            done <= 1'b0;
        end
    end
end

endmodule