module TopModule(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

reg [7:0] out_byte_reg;
reg done_reg;
reg [2:0] state_reg; // 0: IDLE, 1: START, 2: DATA, 3: STOP
reg [2:0] state_next;
reg [3:0] bit_counter_reg;
reg [7:0] data_reg;

always @(*) begin
    state_next = state_reg;
    done_reg = 0;
    case(state_reg)
        0: begin // IDLE
            if (~in) begin
                state_next = 1;
            end
        end
        1: begin // START
            state_next = 2;
            bit_counter_reg = 0;
        end
        2: begin // DATA
            if (bit_counter_reg == 8) begin
                state_next = 3;
            end
            else begin
                state_next = 2;
                bit_counter_reg = bit_counter_reg + 1;
            end
        end
        3: begin // STOP
            if (in) begin
                state_next = 0;
                done_reg = 1;
            end
            else begin
                state_next = 3;
            end
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state_reg <= 0;
        out_byte_reg <= 8'd0;
        done_reg <= 0;
        bit_counter_reg <= 0;
        data_reg <= 8'd0;
    end
    else begin
        state_reg <= state_next;
        if (state_reg == 2) begin
            data_reg = {data_reg[6:0], in};
        end
        if (state_reg == 3 && done_reg) begin
            out_byte_reg <= data_reg;
        end
        done <= done_reg;
        out_byte <= out_byte_reg;
    end
end

endmodule