module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte;
reg done;
reg [2:0] state; // 0: IDLE, 1: RECEIVE_DATA, 2: VERIFY_STOP
reg [2:0] counter; // counter for RECEIVE_DATA state
reg [7:0] data; // shift register for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        counter <= 0;
        data <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // transition to RECEIVE_DATA
                    counter <= 0;
                    data <= 0;
                end
            end
            1: begin // RECEIVE_DATA
                data <= {data[6:0], in}; // shift in data bit
                counter <= counter + 1;
                if (counter == 7) begin // 8 data bits received
                    state <= 2; // transition to VERIFY_STOP
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit verified
                    out_byte <= data; // output received data
                    done <= 1; // assert done signal
                    state <= 0; // transition back to IDLE
                end
            end
            default: state <= 0; // default to IDLE
        endcase
        if (state!= 2) begin // done signal is only valid in VERIFY_STOP state
            done <= 0;
        end
    end
end

endmodule