module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0: IDLE, 1: RECEIVE_BYTE, 2: STOP_CHECK
reg [2:0] data_counter; // counter for data bits
reg [7:0] received_data; // stores received data bits
reg done_reg; // registers done signal

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0;
        data_counter <= 0;
        received_data <= 8'b0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit received
                    state <= 1;
                    data_counter <= 0;
                    received_data <= 8'b0;
                end
            end
            1: begin // RECEIVE_BYTE
                received_data[data_counter] <= in;
                data_counter <= data_counter + 1;
                if (data_counter == 8) begin
                    state <= 2;
                end
            end
            2: begin // STOP_CHECK
                if (in) begin // stop bit received
                    state <= 0;
                    done_reg <= 1;
                end // else stay in STOP_CHECK state
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    done <= done_reg;
    done_reg <= 0; // clear done signal after one clock cycle
end

endmodule