module accu(
    input             clk,
    input             rst_n,
    input      [7:0]  data_in,
    input             valid_in,
    output            valid_out,
    output     [9:0]  data_out
);

reg [1:0]           state;
reg [1:0]           state_next;
reg [9:0]           sum;
reg [9:0]           sum_next;
reg [1:0]           count;
reg [1:0]           count_next;
reg                 valid_out_reg;
reg                 valid_out_next;

localparam IDLE     = 2'b00;
localparam ACCUMULATING = 2'b01;

always @(*) begin
    case(state)
        IDLE: begin
            if(valid_in) begin
                state_next = ACCUMULATING;
                sum_next = data_in;
                count_next = 1;
                valid_out_next = 1'b0;
            end else begin
                state_next = IDLE;
                sum_next = 0;
                count_next = 0;
                valid_out_next = 1'b0;
            end
        end
        ACCUMULATING: begin
            if(valid_in) begin
                if(count == 3) begin
                    state_next = IDLE;
                    sum_next = sum + data_in;
                    count_next = 0;
                    valid_out_next = 1'b1;
                end else begin
                    state_next = ACCUMULATING;
                    sum_next = sum + data_in;
                    count_next = count + 1;
                    valid_out_next = 1'b0;
                end
            end else begin
                state_next = ACCUMULATING;
                sum_next = sum;
                count_next = count;
                valid_out_next = 1'b0;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= IDLE;
        sum <= 0;
        count <= 0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= state_next;
        sum <= sum_next;
        count <= count_next;
        valid_out_reg <= valid_out_next;
    end
end

assign valid_out = (state == IDLE && valid_out_reg) ? 1'b1 : 1'b0;
assign data_out = (state == IDLE && valid_out_reg) ? sum : 10'b0;

endmodule