module accu(
    input               clk,
    input               rst_n,
    input     [7:0]      data_in,
    input               valid_in,
    output              valid_out,
    output    [9:0]      data_out
);

reg     [1:0]            state;
reg     [1:0]            next_state;
reg     [9:0]             sum;
reg     [9:0]             next_sum;
reg                     valid_out_reg;
reg                     next_valid_out;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else begin
        state <= next_state;
        sum <= next_sum;
        valid_out_reg <= next_valid_out;
    end
end

always @(*) begin
    next_state = state;
    next_sum = sum;
    next_valid_out = 1'b0;
    case(state)
        2'b00: begin
            if (valid_in) begin
                next_sum = data_in;
                next_state = 2'b01;
            end
        end
        2'b01: begin
            if (valid_in) begin
                next_sum = sum + data_in;
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin
            if (valid_in) begin
                next_sum = sum + data_in;
                next_state = 2'b11;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin
            if (valid_in) begin
                next_sum = sum + data_in;
                next_state = 2'b00;
                next_valid_out = 1'b1;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule