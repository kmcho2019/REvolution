module accu(
    input               clk,
    input               rst_n,
    input  [7:0]        data_in,
    input               valid_in,
    output              valid_out,
    output [9:0]        data_out
);

reg [1:0]               state;
reg [1:0]               next_state;
reg [9:0]               accu_reg;
reg [9:0]               next_accu;
reg                     valid_out_reg;
reg                     next_valid_out;
reg [1:0]               cnt_reg;
reg [1:0]               next_cnt;

always @(*) begin
    case(state)
        2'b00: begin
            if(valid_in) begin
                next_state = 2'b01;
                next_accu = data_in;
                next_cnt = 1;
                next_valid_out = 1'b0;
            end else begin
                next_state = 2'b00;
                next_accu = accu_reg;
                next_cnt = cnt_reg;
                next_valid_out = 1'b0;
            end
        end
        2'b01: begin
            if(valid_in) begin
                next_state = 2'b10;
                next_accu = accu_reg + data_in;
                next_cnt = cnt_reg + 1;
                next_valid_out = 1'b0;
            end else begin
                next_state = 2'b01;
                next_accu = accu_reg;
                next_cnt = cnt_reg;
                next_valid_out = 1'b0;
            end
        end
        2'b10: begin
            if(valid_in) begin
                next_state = 2'b11;
                next_accu = accu_reg + data_in;
                next_cnt = cnt_reg + 1;
                next_valid_out = 1'b0;
            end else begin
                next_state = 2'b10;
                next_accu = accu_reg;
                next_cnt = cnt_reg;
                next_valid_out = 1'b0;
            end
        end
        2'b11: begin
            if(valid_in) begin
                next_state = 2'b11;
                next_accu = accu_reg + data_in;
                next_cnt = cnt_reg + 1;
                next_valid_out = 1'b0;
            end else begin
                next_state = 2'b11;
                next_accu = accu_reg;
                next_cnt = cnt_reg;
                next_valid_out = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00;
            next_accu = 10'b0;
            next_cnt = 2'b0;
            next_valid_out = 1'b0;
        end
    endcase

    if(cnt_reg == 4'b100) begin
        next_valid_out = 1'b1;
        next_state = 2'b00;
        next_accu = 10'b0;
        next_cnt = 2'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= 2'b00;
        accu_reg <= 10'b0;
        valid_out_reg <= 1'b0;
        cnt_reg <= 2'b0;
    end else begin
        state <= next_state;
        accu_reg <= next_accu;
        valid_out_reg <= next_valid_out;
        cnt_reg <= next_cnt;
    end
end

assign data_out = accu_reg;
assign valid_out = valid_out_reg;

endmodule