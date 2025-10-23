module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] data_cnt; // counter for data bits
reg [7:0] data_reg; // shift register for data bits

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        data_cnt <= 0;
        data_reg <= 8'b0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                data_cnt <= 1; // start counting data bits
                data_reg <= {7'b0, in}; // shift in first data bit
            end
            2: begin // DATA
                if (data_cnt < 8) begin
                    data_cnt <= data_cnt + 1;
                    data_reg <= {data_reg[6:0], in}; // shift in next data bit
                end else begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit verified
                    state <= 0; // IDLE
                    out_byte <= data_reg; // output received data byte
                    done <= 1;
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state!= 3) begin // not in STOP state
            done <= 0;
        end
    end
end

endmodule