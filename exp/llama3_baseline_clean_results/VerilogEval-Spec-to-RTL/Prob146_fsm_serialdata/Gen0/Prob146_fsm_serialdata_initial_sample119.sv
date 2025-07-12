module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [7:0] data;
reg [2:0] bit_cnt;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE state
        done <= 0;
        data <= 8'h00;
        bit_cnt <= 0;
    end else begin
        case (state)
            0: begin // IDLE state
                if (~in) begin // Start bit detected
                    state <= 1; // Move to START state
                    data <= 8'h00;
                    bit_cnt <= 0;
                end
            end
            1: begin // START state
                data[0] <= in; // Store the first data bit
                state <= 2; // Move to DATA state
                bit_cnt <= 1;
            end
            2: begin // DATA state
                data[bit_cnt] <= in; // Store the incoming data bit
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 7) begin // All 8 data bits received
                    state <= 3; // Move to STOP state
                end
            end
            3: begin // STOP state
                if (in) begin // Stop bit is correct
                    done <= 1; // Assert done signal
                    out_byte <= {data[7:1], data[0]}; // Output the received byte (LSB first)
                    state <= 0; // Move back to IDLE state
                end else begin // Stop bit is incorrect, wait for a stop bit
                    state <= 3; // Stay in STOP state
                end
            end
            default: state <= 0;
        endcase
        if (state != 3) begin // Clear done signal when not in STOP state
            done <= 0;
        end
    end
end

endmodule