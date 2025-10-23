module TopModule(
    input  clk,
    input  reset,
    input  in,
    output reg done
);

reg [2:0] state; // 0: IDLE, 1: START_BIT, 2: DATA_BITS, 3: STOP_BIT
reg [7:0] data;
reg [2:0] bit_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_counter <= 0;
        data <= 8'b0;
        done <= 1'b0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 1; // START_BIT
                    bit_counter <= 0;
                end
            end
            1: begin // START_BIT
                state <= 2; // DATA_BITS
                bit_counter <= 1;
                data[0] <= in;
            end
            2: begin // DATA_BITS
                bit_counter <= bit_counter + 1;
                data <= {data[6:0], in};
                if (bit_counter == 7) begin
                    state <= 3; // STOP_BIT
                end
            end
            3: begin // STOP_BIT
                if (in) begin // stop bit detected
                    state <= 0; // IDLE
                    done <= 1'b1;
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state == 0 && ~reset) begin
        done <= 1'b0;
    end
end

endmodule