module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

parameter IDLE = 4'b0000;
parameter START = 4'b0001;
parameter DATA = 4'b0010;
parameter STOP = 4'b0011;

reg [3:0] state;
reg [7:0] byte;
reg [2:0] bit_counter;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin // start bit detected
                    state <= START;
                    byte <= 8'b00000000;
                    bit_counter <= 0;
                end
            end
            START: begin
                byte[0] <= in;
                bit_counter <= bit_counter + 1;
                if (bit_counter == 8) begin
                    state <= STOP;
                end else begin
                    state <= DATA;
                end
            end
            DATA: begin
                if (bit_counter == 8) begin
                    state <= STOP;
                end else begin
                    byte[bit_counter] <= in;
                    bit_counter <= bit_counter + 1;
                end
            end
            STOP: begin
                if (in) begin // stop bit detected
                    state <= IDLE;
                    done_reg <= 1;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        out_byte <= byte;
        done <= done_reg;
        done_reg <= 0;
    end else begin
        done <= 0;
    end
end

endmodule