module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg     [1:0]   state;  // 0: idle, 1: accumulate, 2: output
reg     [1:0]   state_next;
reg     [9:0]   accu_sum;
reg     [9:0]   accu_sum_next;
reg     [1:0]   cnt;
reg     [1:0]   cnt_next;
reg             valid_out_reg;
reg             valid_out_next;

always @(*) begin
    case(state)
        2'b00: begin  // idle state
            if(valid_in) begin
                state_next = 2'b01;
                accu_sum_next = data_in;
                cnt_next = 1;
                valid_out_next = 1'b0;
            end else begin
                state_next = 2'b00;
                accu_sum_next = accu_sum;
                cnt_next = cnt;
                valid_out_next = 1'b0;
            end
        end
        2'b01: begin  // accumulate state
            if(valid_in) begin
                if(cnt == 3) begin
                    state_next = 2'b10;
                    accu_sum_next = accu_sum + data_in;
                    cnt_next = cnt + 1;
                    valid_out_next = 1'b1;
                end else begin
                    state_next = 2'b01;
                    accu_sum_next = accu_sum + data_in;
                    cnt_next = cnt + 1;
                    valid_out_next = 1'b0;
                end
            end else begin
                state_next = 2'b01;
                accu_sum_next = accu_sum;
                cnt_next = cnt;
                valid_out_next = 1'b0;
            end
        end
        2'b10: begin  // output state
            state_next = 2'b00;
            accu_sum_next = 10'b0;
            cnt_next = 2'b0;
            valid_out_next = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= 2'b00;
        accu_sum <= 10'b0;
        cnt <= 2'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= state_next;
        accu_sum <= accu_sum_next;
        cnt <= cnt_next;
        valid_out_reg <= valid_out_next;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (state == 2'b10)? accu_sum : 10'b0;

endmodule