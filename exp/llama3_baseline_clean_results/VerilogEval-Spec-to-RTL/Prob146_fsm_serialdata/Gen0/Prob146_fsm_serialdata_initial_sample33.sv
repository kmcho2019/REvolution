module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state; // 0: IDLE, 1: RECEIVE_BYTE, 2: VERIFY_STOP
reg [2:0] bit_counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        bit_counter <= 0;
        done_reg <= 0;
        out_byte_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // RECEIVE_BYTE
                    bit_counter <= 0;
                end
            end
            1: begin // RECEIVE_BYTE
                out_byte_reg[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    state <= 2; // VERIFY_STOP
                end
            end
            2: begin // VERIFY_STOP
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state <= 0; // IDLE
                end
            end
            default: state <= 0; // IDLE
        endcase
        if (state != 2) begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule