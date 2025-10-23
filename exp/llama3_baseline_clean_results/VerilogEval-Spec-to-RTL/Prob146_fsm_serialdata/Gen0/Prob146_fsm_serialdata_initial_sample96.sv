module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] data_byte;
reg [2:0] state; // 0: IDLE, 1: START, 2: STOP
reg [2:0] bit_counter;
reg done_reg;

always @ (posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_counter <= 0;
        done_reg <= 0;
        data_byte <= 8'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                    bit_counter <= 0;
                    data_byte <= 8'b0;
                end
            end
            1: begin // START
                data_byte <= {data_byte[6:0], in}; // shift in data bit
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign out_byte = data_byte;
assign done = done_reg;

always @ (posedge clk) begin
    if (!reset) begin
        done_reg <= 0;
    end
end

endmodule