module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [2:0] state; // 0: IDLE, 1: RECEIVE_DATA, 2: VERIFY_STOP
reg [7:0] data_byte;
reg [2:0] bit_counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_counter <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // RECEIVE_DATA
                    bit_counter <= 0;
                    data_byte <= 0;
                end else begin
                    state <= 0; // IDLE
                end
            end
            1: begin // RECEIVE_DATA
                data_byte <= {data_byte[6:0], in}; // shift in the new bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    state <= 2; // VERIFY_STOP
                end else begin
                    state <= 1; // RECEIVE_DATA
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done_reg <= 1;
                end else begin
                    state <= 2; // VERIFY_STOP
                end
            end
        endcase
    end
end

assign out_byte = data_byte;
assign done = done_reg;

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (state == 2) begin
        done_reg <= in;
    end else begin
        done_reg <= 0;
    end
end

endmodule