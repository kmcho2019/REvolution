module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

reg [7:0] data_reg;
reg [2:0] state;
reg [3:0] bit_counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_counter <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // DATA
                    bit_counter <= 1;
                    data_reg[0] <= ~in;
                end
            end
            1: begin // DATA
                if (bit_counter < 8) begin
                    data_reg[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                end else if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done_reg <= 1;
                end else begin // no stop bit, wait for stop bit
                    state <= 2; // STOP
                end
            end
            2: begin // STOP
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                end
            end
        endcase
    end
end

assign done = done_reg;
always @(posedge clk) begin
    if (~reset) begin
        done_reg <= 0;
    end
end

endmodule