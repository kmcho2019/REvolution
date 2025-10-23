module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output              valid_out,
    output      [9:0]   data_out
);

reg [1:0] state;
reg [1:0] state_next;
reg [9:0] sum;
reg [9:0] sum_next;
reg [1:0] count;
reg [1:0] count_next;
reg       valid_out_reg;
reg       valid_out_next;

parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;
parameter OUTPUT = 2'b10;

always @(*) begin
    case(state)
        IDLE: begin
            if(valid_in) begin
                state_next = ACCUMULATE;
                count_next = 1;
                sum_next = data_in;
                valid_out_next = 0;
            end
            else begin
                state_next = IDLE;
                count_next = 0;
                sum_next = 0;
                valid_out_next = 0;
            end
        end
        ACCUMULATE: begin
            if(count < 4) begin
                state_next = ACCUMULATE;
                count_next = count + 1;
                sum_next = sum + data_in;
                valid_out_next = 0;
            end
            else begin
                state_next = OUTPUT;
                count_next = 0;
                sum_next = sum + data_in;
                valid_out_next = 1;
            end
        end
        OUTPUT: begin
            state_next = IDLE;
            count_next = 0;
            sum_next = 0;
            valid_out_next = 0;
        end
        default: begin
            state_next = IDLE;
            count_next = 0;
            sum_next = 0;
            valid_out_next = 0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
        sum <= 0;
        count <= 0;
        valid_out_reg <= 0;
    end
    else begin
        state <= state_next;
        sum <= sum_next;
        count <= count_next;
        valid_out_reg <= valid_out_next;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule