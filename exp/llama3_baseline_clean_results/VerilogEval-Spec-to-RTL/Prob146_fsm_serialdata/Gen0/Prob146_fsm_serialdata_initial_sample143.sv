module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: DATA, 2: STOP
reg [2:0] bit_cnt; // counter for data bits
reg [7:0] shift_reg; // shift register for data bits

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_cnt <= 0;
        shift_reg <= 8'b0;
        done <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // DATA
                    shift_reg <= 8'b0;
                    bit_cnt <= 0;
                end
            end
            1: begin // DATA
                shift_reg <= {shift_reg[6:0], in}; // shift in data bit
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == 8) begin
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    out_byte <= shift_reg; // output received data byte
                    done <= 1;
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (state == 2 && !done) begin // STOP state and done not asserted
        done <= 0;
    end
end

endmodule