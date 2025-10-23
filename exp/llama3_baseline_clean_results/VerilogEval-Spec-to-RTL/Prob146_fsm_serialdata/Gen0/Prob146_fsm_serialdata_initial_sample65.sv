module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte;
reg done;
reg [2:0] state; // 0: IDLE, 1: RECEIVE, 2: STOP, 3: DONE
reg [2:0] bit_counter;
reg [7:0] data_byte;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        done <= 0;
        bit_counter <= 0;
        out_byte <= 0;
        data_byte <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // RECEIVE
                    bit_counter <= 0;
                    data_byte <= 0;
                end
            end
            1: begin // RECEIVE
                data_byte <= {data_byte[6:0], in}; // collect data bits
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    state <= 3; // DONE
                    out_byte <= data_byte;
                end
            end
            3: begin // DONE
                done <= 1;
                state <= 0; // IDLE
            end
            default: state <= 0;
        endcase
    end
end

always @(posedge clk) begin
    if (!reset && state == 3) begin // clear done signal
        done <= 0;
    end
end

endmodule