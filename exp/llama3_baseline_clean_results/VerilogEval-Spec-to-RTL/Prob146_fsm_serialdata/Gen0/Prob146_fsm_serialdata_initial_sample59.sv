module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;
reg [2:0] bit_pos;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; // IDLE
        bit_pos <= 3'b000;
        out_byte_reg <= 8'b0;
        done_reg <= 1'b0;
    end else begin
        case (state)
            3'b000: begin // IDLE
                if (~in) begin // start bit detected
                    state <= 3'b001; // START
                end
            end
            3'b001: begin // START
                state <= 3'b010; // DATA
            end
            3'b010: begin // DATA
                out_byte_reg[bit_pos] <= in;
                bit_pos <= bit_pos + 1'b1;
                if (bit_pos == 3'b111) begin
                    state <= 3'b011; // STOP
                end
            end
            3'b011: begin // STOP
                if (in) begin // stop bit detected
                    state <= 3'b000; // IDLE
                    done_reg <= 1'b1;
                end
            end
            default: state <= 3'b000;
        endcase
    end
end

always @(posedge clk) begin
    out_byte <= out_byte_reg;
    done <= done_reg;
    if (state == 3'b011 && in) begin
        done_reg <= 1'b0;
    end
end

endmodule