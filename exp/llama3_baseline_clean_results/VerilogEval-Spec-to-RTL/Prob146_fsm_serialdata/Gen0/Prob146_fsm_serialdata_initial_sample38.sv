module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [1:0] state_reg; // 0: idle, 1: start, 2: receiving, 3: stop
reg [2:0] bit_counter_reg;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0; // idle
        bit_counter_reg <= 0;
        done_reg <= 0;
        out_byte_reg <= 0;
    end else begin
        case (state_reg)
            0: begin // idle
                if (!in) begin // start bit detected
                    state_reg <= 1; // start
                end
            end
            1: begin // start
                state_reg <= 2; // receiving
                out_byte_reg <= 0;
                bit_counter_reg <= 0;
            end
            2: begin // receiving
                out_byte_reg[bit_counter_reg] <= in;
                bit_counter_reg <= bit_counter_reg + 1;
                if (bit_counter_reg == 7) begin
                    state_reg <= 3; // stop
                end
            end
            3: begin // stop
                if (in) begin // stop bit detected
                    done_reg <= 1;
                    state_reg <= 0; // idle
                end
            end
        endcase
    end
end

always @(posedge clk) begin
    if (state_reg != 3) begin // not in stop state
        done_reg <= 0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule