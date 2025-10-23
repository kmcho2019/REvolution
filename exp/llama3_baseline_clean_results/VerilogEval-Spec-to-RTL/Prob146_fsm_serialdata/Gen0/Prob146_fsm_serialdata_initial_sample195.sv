module TopModule(
    input  clk,
    input  in,
    input  reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] state_next;
reg [3:0] data_cnt;
reg [3:0] data_cnt_next;
reg done_reg;
reg done_next;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state_reg <= 0;
        data_cnt <= 0;
        out_byte_reg <= 8'd0;
        done_reg <= 1'b0;
    end else begin
        state_reg <= state_next;
        data_cnt <= data_cnt_next;
        out_byte_reg <= out_byte_reg;
        done_reg <= done_next;

        case (state_reg)
            0: begin // IDLE
                if (~in) begin
                    state_next = 1; // START
                    data_cnt_next = 0;
                end else begin
                    state_next = 0;
                    data_cnt_next = 0;
                end
            end
            1: begin // START
                state_next = 2; // DATA
                data_cnt_next = 0;
            end
            2: begin // DATA
                out_byte_reg[7 - data_cnt] = in;
                if (data_cnt == 7) begin
                    state_next = 3; // STOP
                    data_cnt_next = 0;
                end else begin
                    state_next = 2;
                    data_cnt_next = data_cnt + 1;
                end
            end
            3: begin // STOP
                if (in) begin
                    state_next = 0; // IDLE
                    data_cnt_next = 0;
                    done_next = 1'b1;
                end else begin
                    state_next = 3;
                    data_cnt_next = 0;
                    done_next = 1'b0;
                end
            end
            default: begin
                state_next = 0;
                data_cnt_next = 0;
            end
        endcase
    end
end

always @(*) begin
    case (state_reg)
        0: done_next = 1'b0;
        1: done_next = 1'b0;
        2: done_next = 1'b0;
        3: done_next = 1'b1;
        default: done_next = 1'b0;
    endcase
end

assign out_byte = (done_reg)? out_byte_reg : 8'd0;
assign done = done_reg;

endmodule