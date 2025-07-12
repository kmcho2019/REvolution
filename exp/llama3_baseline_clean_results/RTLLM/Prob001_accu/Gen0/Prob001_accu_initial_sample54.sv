module accu(
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg     [1:0]       state;
reg     [1:0]       next_state;
reg     [9:0]       sum;
reg     [9:0]       next_sum;
reg     [1:0]       count;
reg     [1:0]       next_count;
reg                 valid_out_reg;
reg                 next_valid_out;

always @(*) begin
    case(state)
        2'b00: begin // IDLE
            if(valid_in) begin
                next_state = 2'b01;
                next_sum = data_in;
                next_count = 1;
                next_valid_out = 1'b0;
            end
            else begin
                next_state = 2'b00;
                next_sum = 10'd0;
                next_count = 2'd0;
                next_valid_out = 1'b0;
            end
        end
        2'b01: begin // ACCUMULATE
            if(valid_in) begin
                next_state = 2'b01;
                next_sum = sum + data_in;
                next_count = count + 1;
                if(count == 2'd3) begin
                    next_valid_out = 1'b1;
                end
                else begin
                    next_valid_out = 1'b0;
                end
            end
            else begin
                next_state = 2'b01;
                next_sum = sum;
                next_count = count;
                next_valid_out = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00;
            next_sum = 10'd0;
            next_count = 2'd0;
            next_valid_out = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= 2'b00;
        sum <= 10'd0;
        count <= 2'd0;
        valid_out_reg <= 1'b0;
    end
    else begin
        state <= next_state;
        sum <= next_sum;
        count <= next_count;
        valid_out_reg <= next_valid_out;
        if(next_valid_out) begin
            next_state <= 2'b00;
            next_sum <= 10'd0;
            next_count <= 2'd0;
        end
    end
end

assign data_out = sum;
assign valid_out = valid_out_reg;

endmodule