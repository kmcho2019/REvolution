module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state; // 0: idle, 1: start_bit, 2: data_bits, 3: stop_bit
reg [2:0] data_count;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // idle
        done_reg <= 0;
        data_count <= 0;
    end else begin
        case (state)
            0: begin // idle
                if (!in) begin // start bit detected
                    state <= 1; // start_bit
                end
            end
            1: begin // start_bit
                state <= 2; // data_bits
                data_count <= 1;
            end
            2: begin // data_bits
                data_count <= data_count + 1;
                if (data_count == 8) begin
                    state <= 3; // stop_bit
                end
            end
            3: begin // stop_bit
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // idle
                end
            end
            default: begin
                state <= 0; // idle
            end
        endcase
        if (state == 0 && done_reg) begin // done should be high for one clock cycle
            done_reg <= 0;
        end
    end
end

assign done = done_reg;

endmodule