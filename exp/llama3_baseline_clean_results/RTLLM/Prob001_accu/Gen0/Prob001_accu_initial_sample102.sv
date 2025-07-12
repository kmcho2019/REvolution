module accu (
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output              valid_out,
    output      [9:0]   data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg [7:0] data_reg [3:0];
reg [9:0] sum_reg;
reg [1:0] cnt_reg;
reg       valid_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
        sum_reg <= 10'b0;
        cnt_reg <= 2'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        if (state == 2'b11) begin
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
        if (next_state == 2'b01) begin
            data_reg[0] <= data_in;
            cnt_reg <= cnt_reg + 1'b1;
            sum_reg <= data_in;
        end else if (next_state == 2'b10) begin
            case (cnt_reg)
                2'b01: begin
                    data_reg[1] <= data_in;
                    sum_reg <= sum_reg + data_in;
                end
                2'b10: begin
                    data_reg[2] <= data_in;
                    sum_reg <= sum_reg + data_in;
                end
                2'b11: begin
                    data_reg[3] <= data_in;
                    sum_reg <= sum_reg + data_in;
                end
            endcase
            cnt_reg <= cnt_reg + 1'b1;
        end
    end
end

always @(*) begin
    case (state)
        2'b00: begin
            if (valid_in) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (valid_in) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin
            if (valid_in) begin
                if (cnt_reg == 2'b11) begin
                    next_state = 2'b11;
                end else begin
                    next_state = 2'b10;
                end
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin
            next_state = 2'b00;
        end
    endcase
end

assign valid_out = valid_out_reg;
assign data_out = sum_reg;

endmodule