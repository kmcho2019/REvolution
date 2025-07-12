module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [3:0] counter_reg;

parameter IDLE = 0;
parameter START = 1;
parameter DATA = 2;
parameter STOP = 3;

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        out_byte_reg <= 8'b0;
        done_reg <= 0;
        counter_reg <= 0;
    end else begin
        case (state_reg)
            IDLE: begin
                if (!in) begin // start bit received
                    state_reg <= START;
                    out_byte_reg <= 8'b0;
                    counter_reg <= 0;
                end else begin
                    state_reg <= IDLE;
                end
            end
            START: begin
                state_reg <= DATA;
            end
            DATA: begin
                out_byte_reg <= {out_byte_reg[6:0], in};
                counter_reg <= counter_reg + 1;
                if (counter_reg == 8) begin
                    state_reg <= STOP;
                end
            end
            STOP: begin
                if (in) begin // stop bit received
                    done_reg <= 1;
                    state_reg <= IDLE;
                end else begin
                    state_reg <= STOP;
                end
            end
            default: state_reg <= IDLE;
        endcase
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule