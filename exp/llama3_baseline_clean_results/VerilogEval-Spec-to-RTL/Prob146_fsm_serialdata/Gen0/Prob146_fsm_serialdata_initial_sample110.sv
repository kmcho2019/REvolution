module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;

reg [2:0] state;
reg [2:0] next_state;

reg [7:0] data_bits;
reg [2:0] bit_counter;

always @(posedge clk) begin
    if (reset) begin
        state <= 0;
        out_byte_reg <= 0;
        done_reg <= 0;
        data_bits <= 0;
        bit_counter <= 0;
    end else begin
        state <= next_state;
        case (state)
            0: begin // idle state
                if (in == 0) begin // start bit detected
                    next_state <= 1;
                    data_bits <= 0;
                    bit_counter <= 0;
                end else begin
                    next_state <= 0;
                end
            end
            1: begin // data bit reception state
                data_bits[bit_counter] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 7) begin
                    next_state <= 2;
                end else begin
                    next_state <= 1;
                end
            end
            2: begin // stop bit verification state
                if (in == 1) begin // stop bit verified
                    next_state <= 0;
                    out_byte_reg <= {data_bits[6:0], data_bits[7]};
                    done_reg <= 1;
                end else begin // stop bit missing, wait for next stop bit
                    next_state <= 2;
                end
            end
            default: next_state <= 0;
        endcase
        if (state == 2 && in == 1) begin
            done_reg <= 1;
        end else begin
            done_reg <= 0;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule