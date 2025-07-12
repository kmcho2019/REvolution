module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] bit_index;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= 0; // IDLE
        out_byte_reg <= 8'h00;
        bit_index <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (!in) begin // start bit detected
                    state <= 1; // START
                end
            end
            1: begin // START
                state <= 2; // DATA
                bit_index <= 0;
            end
            2: begin // DATA
                out_byte_reg[bit_index] <= in;
                bit_index <= bit_index + 1;
                if (bit_index == 7) begin
                    state <= 3; // STOP
                end
            end
            3: begin // STOP
                if (in) begin // stop bit correct
                    state <= 0; // IDLE
                    done_reg <= 1;
                end
            end
            default: state <= 0; // IDLE
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done_reg <= 0;
    end else if (state == 3 && in) begin // STOP state and stop bit correct
        done_reg <= 1;
    end else begin
        done_reg <= 0;
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule