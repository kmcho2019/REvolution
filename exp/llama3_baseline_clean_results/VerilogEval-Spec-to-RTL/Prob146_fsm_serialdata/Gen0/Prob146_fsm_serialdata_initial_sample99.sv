module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // Idle, Receive, Stop, Error
reg [2:0] bit_count; // Count the number of bits received
reg [7:0] byte; // Register to store the received byte

always @(posedge clk) begin
    if (reset) begin // Synchronous reset
        state <= 0; // Idle
        done <= 0;
        out_byte <= 0;
    end else begin
        case (state)
            0: begin // Idle
                if (!in) begin // Start bit detected
                    state <= 1; // Receive
                    bit_count <= 0;
                    byte <= 0;
                end
            end
            1: begin // Receive
                byte <= {byte[6:0], in}; // Shift in the received bit
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= 2; // Stop
                end
            end
            2: begin // Stop
                if (in) begin // Stop bit verified
                    out_byte <= byte;
                    done <= 1;
                    state <= 0; // Idle
                end else begin // Stop bit error
                    state <= 3; // Error
                end
            end
            3: begin // Error
                if (in) begin // Stop bit detected
                    state <= 0; // Idle
                end
            end
            default: state <= 0; // Idle
        endcase
        if (state!= 2) begin // Not in Stop state
            done <= 0;
        end
    end
end

endmodule