module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg     [1:0]   state;
reg     [1:0]   next_state;
reg     [9:0]   sum;
reg     [9:0]   next_sum;
reg             valid_out_reg;
reg             next_valid_out;
reg     [1:0]   count;
reg     [1:0]   next_count;

always @(*) begin
    next_state = state;
    next_sum = sum;
    next_valid_out = 0;
    next_count = count;
    
    case(state)
        2'b00: begin // idle state
            if(valid_in) begin
                next_state = 2'b01;
                next_sum = data_in;
                next_count = 1;
            end
        end
        2'b01: begin // accumulating state
            if(valid_in) begin
                next_sum = sum + data_in;
                next_count = count + 1;
            end
            if(count == 4) begin
                next_state = 2'b00;
                next_valid_out = 1;
            end
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= 2'b00;
        sum <= 0;
        valid_out_reg <= 0;
        count <= 0;
    end else begin
        state <= next_state;
        sum <= next_sum;
        valid_out_reg <= next_valid_out;
        count <= next_count;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule