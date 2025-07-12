module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

logic [1:0] state, next_state;

logic [7:0] byte;
logic [2:0] bit_count;

always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        out_byte <= 8'b0;
        done <= 1'b0;
        byte <= 8'b0;
        bit_count <= 3'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    next_state <= START;
                end else begin
                    next_state <= IDLE;
                end
            end
            START: begin
                next_state <= DATA;
                byte[0] <= in;
                bit_count <= 1;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state <= STOP;
                    byte[7] <= in;
                end else begin
                    next_state <= DATA;
                    byte[bit_count + 1] <= in;
                    bit_count <= bit_count + 1;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    next_state <= IDLE;
                    out_byte <= byte;
                    done <= 1'b1;
                end else begin
                    next_state <= STOP;
                end
            end
            default: next_state <= IDLE;
        endcase
        if (state!= STOP || in!= 1'b1) begin
            done <= 1'b0;
        end
    end
end

endmodule