module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state; // 0: IDLE, 1: RECEIVE_DATA, 2: VERIFY_STOP
reg [3:0] bit_counter;
reg [7:0] data_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        done_reg <= 0;
        out_byte_reg <= 0;
        bit_counter <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin
                    state <= 1;
                    bit_counter <= 0;
                    data_reg <= 0;
                end
            end
            1: begin // RECEIVE_DATA
                data_reg[7 - bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= 2;
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit is correct
                    state <= 0;
                    done_reg <= 1;
                    out_byte_reg <= data_reg;
                end
            end
            default: state <= 0;
        endcase
        if (state!= 2 || in) begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule