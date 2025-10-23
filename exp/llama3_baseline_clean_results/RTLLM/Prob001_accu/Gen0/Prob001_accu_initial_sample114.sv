module accu (
    input            clk,
    input            rst_n,
    input      [7:0]  data_in,
    input            valid_in,
    output           valid_out,
    output  [9:0]     data_out
);

reg [1:0]  state;
reg [1:0]  state_next;
reg [9:0]  sum;
reg [9:0]  sum_next;
reg [1:0]  cnt;
reg [1:0]  cnt_next;
reg        valid_out_reg;
reg        valid_out_next;

// State definition
parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;

// Initialize state and sum
initial state = IDLE;
initial sum = 10'b0;
initial cnt = 2'b0;
initial valid_out_reg = 1'b0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sum <= 10'b0;
        cnt <= 2'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= state_next;
        sum <= sum_next;
        cnt <= cnt_next;
        valid_out_reg <= valid_out_next;
    end
end

always @(*) begin
    state_next = state;
    sum_next = sum;
    cnt_next = cnt;
    valid_out_next = 1'b0;

    case (state)
        IDLE: begin
            if (valid_in) begin
                state_next = ACCUMULATE;
                sum_next = data_in;
                cnt_next = 2'b1;
            end
        end
        ACCUMULATE: begin
            if (valid_in) begin
                if (cnt == 2'b11) begin
                    sum_next = sum + data_in;
                    cnt_next = 2'b00;
                    state_next = IDLE;
                    valid_out_next = 1'b1;
                end else begin
                    sum_next = sum + data_in;
                    cnt_next = cnt + 1'b1;
                end
            end else begin
                cnt_next = cnt;
            end
        end
    endcase
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule