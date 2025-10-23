module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

reg [2:0] state; // 3 states: IDLE (0), START_BIT (1), DATA_BITS (2), STOP_BIT (3), ERROR (4)
reg [7:0] data; // to store the received data bits
reg [2:0] bit_count; // counter for the data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // transition to START_BIT
                end
            end
            1: begin // START_BIT
                state <= 2; // transition to DATA_BITS
                bit_count <= 0; // reset data bit counter
            end
            2: begin // DATA_BITS
                data[bit_count] <= in; // store the current data bit
                bit_count <= bit_count + 1;
                if (bit_count == 7) begin
                    state <= 3; // transition to STOP_BIT
                end
            end
            3: begin // STOP_BIT
                if (in) begin // stop bit verified
                    done <= 1; // assert done signal
                    state <= 0; // transition to IDLE
                end else begin // stop bit not verified
                    state <= 4; // transition to ERROR
                end
            end
            4: begin // ERROR
                if (in) begin // stop bit detected
                    state <= 0; // transition to IDLE
                end
            end
        endcase
        if (state == 0) begin // reset done signal in IDLE state
            done <= 0;
        end
    end
end

endmodule