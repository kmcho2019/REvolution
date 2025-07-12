module accu (
    input         clk,
    input         rst_n,
    input  [7:0]  data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [1:0]  state;
reg [1:0]  next_state;
reg [9:0]  accu_reg;
reg [9:0]  next_accu_reg;
reg [1:0]  cnt_reg;
reg [1:0]  next_cnt_reg;
reg         valid_out_reg;
reg         next_valid_out_reg;

parameter IDLE = 2'b00;
parameter ACCU = 2'b01;
parameter OUTPUT = 2'b10;

always @(*) begin
    next_state = state;
    next_accu_reg = accu_reg;
    next_cnt_reg = cnt_reg;
    next_valid_out_reg = 1'b0;

    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = ACCU;
                next_accu_reg = data_in;
                next_cnt_reg = 1'b01;
            end
        end
        ACCU: begin
            if (valid_in) begin
                next_accu_reg = accu_reg + data_in;
                next_cnt_reg = cnt_reg + 1'b01;
                if (cnt_reg == 2'b11) begin
                    next_state = OUTPUT;
                end
            end
        end
        OUTPUT: begin
            next_valid_out_reg = 1'b1;
            next_state = IDLE;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        accu_reg <= 10'b0;
        cnt_reg <= 2'b00;
        valid_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        accu_reg <= next_accu_reg;
        cnt_reg <= next_cnt_reg;
        valid_out_reg <= next_valid_out_reg;
    end
end

assign valid_out = valid_out_reg;
assign data_out = accu_reg;

endmodule