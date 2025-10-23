module TopModule (
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state_reg, state_next;
reg [2:0] count_reg, count_next;
reg [7:0] data_reg, data_next;
reg done_reg, done_next;

parameter IDLE = 3'b000, START_BIT = 3'b001, DATA_BITS = 3'b010, STOP_BIT = 3'b011, ERROR = 3'b100;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (~in) begin
                state_next = START_BIT;
                count_next = 8;
                data_next = 8'b0;
            end else begin
                state_next = IDLE;
                count_next = count_reg;
                data_next = data_reg;
            end
        end
        START_BIT: begin
            state_next = DATA_BITS;
            count_next = count_reg - 1;
            data_next = {data_reg[6:0], in};
        end
        DATA_BITS: begin
            if (count_reg == 1) begin
                state_next = STOP_BIT;
                count_next = 0;
                data_next = {data_reg[6:0], in};
            end else begin
                state_next = DATA_BITS;
                count_next = count_reg - 1;
                data_next = {data_reg[6:0], in};
            end
        end
        STOP_BIT: begin
            if (in) begin
                state_next = IDLE;
                count_next = 0;
                data_next = data_reg;
                done_next = 1'b1;
            end else begin
                state_next = ERROR;
                count_next = count_reg;
                data_next = data_reg;
            end
        end
        ERROR: begin
            if (in) begin
                state_next = IDLE;
                count_next = 0;
                data_next = 8'b0;
            end else begin
                state_next = ERROR;
                count_next = count_reg;
                data_next = data_reg;
            end
        end
        default: begin
            state_next = IDLE;
            count_next = 0;
            data_next = 8'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= IDLE;
        count_reg <= 0;
        data_reg <= 8'b0;
        done_reg <= 1'b0;
        out_byte_reg <= 8'b0;
    end else begin
        state_reg <= state_next;
        count_reg <= count_next;
        data_reg <= data_next;
        done_reg <= done_next;
        if (done_next) begin
            out_byte_reg <= data_reg;
        end
    end
end

assign out_byte = out_byte_reg;
assign done = done_reg;

endmodule