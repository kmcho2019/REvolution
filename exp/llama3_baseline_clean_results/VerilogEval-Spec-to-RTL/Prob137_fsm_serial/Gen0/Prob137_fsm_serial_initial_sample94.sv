module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP, 4: DONE
reg [7:0] data; // received byte
reg [2:0] bit_counter; // counter for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // reset to IDLE state
        done <= 0;
        data <= 8'h00;
        bit_counter <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit received
                    state <= 1; // move to START state
                    bit_counter <= 0;
                end else begin
                    state <= 0; // stay in IDLE state
                end
            end
            1: begin // START
                state <= 2; // move to DATA state
            end
            2: begin // DATA
                data[bit_counter] <= in; // receive data bit
                if (bit_counter == 7) begin
                    state <= 3; // move to STOP state
                end else begin
                    bit_counter <= bit_counter + 1;
                end
            end
            3: begin // STOP
                if (in) begin // stop bit received
                    state <= 4; // move to DONE state
                    done <= 1; // set done signal
                end else begin // stop bit not received, wait for stop bit
                    state <= 3;
                end
            end
            4: begin // DONE
                done <= 0; // reset done signal
                state <= 0; // move back to IDLE state
            end
        endcase
    end
end

endmodule