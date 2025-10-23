module TopModule (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state;

parameter IDLE = 3'b001;
parameter START = 3'b010;
parameter DATA = 3'b011;
parameter STOP = 3'b100;
parameter ERROR = 3'b101;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
        out_byte_reg <= 8'b0;
    end else begin
        case (state)
            IDLE: begin
                if (~in) begin
                    state <= START;
                end else begin
                    state <= IDLE;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                out_byte_reg[0] <= in;
                state <= (out_byte_reg[7] == 1'b0) ? DATA : STOP;
                out_byte_reg <= {out_byte_reg[6:0], 1'b0};
            end
            STOP: begin
                if (in) begin
                    done_reg <= 1'b1;
                    state <= IDLE;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if (in) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (done_reg) begin
        out_byte <= out_byte_reg;
        done <= 1'b1;
    end else begin
        done <= 1'b0;
    end
end

endmodule