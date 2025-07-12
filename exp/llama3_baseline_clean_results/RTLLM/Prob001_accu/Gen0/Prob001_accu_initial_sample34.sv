module accu(
    input               clk,
    input               rst_n,
    input       [7:0]   data_in,
    input               valid_in,
    output              valid_out,
    output      [9:0]   data_out
);

reg [1:0]        state;
reg [1:0]        next_state;
reg [9:0]        accu_sum;
reg [9:0]        next_accu_sum;
reg [1:0]        count;
reg [1:0]        next_count;
reg               valid_out_reg;
reg               next_valid_out;

always @(*) begin
    case(state)
        2'b00: begin // idle state
            if(valid_in) begin
                next_state = 2'b01;
                next_accu_sum = data_in;
                next_count = 1;
                next_valid_out = 1'b0;
            end
            else begin
                next_state = 2'b00;
                next_accu_sum = 0;
                next_count = 0;
                next_valid_out = 1'b0;
            end
        end
        2'b01: begin // accumulation state
            if(valid_in) begin
                if(count == 3) begin
                    next_state = 2'b00;
                    next_accu_sum = accu_sum + data_in;
                    next_count = 0;
                    next_valid_out = 1'b1;
                end
                else begin
                    next_state = 2'b01;
                    next_accu_sum = accu_sum + data_in;
                    next_count = count + 1;
                    next_valid_out = 1'b0;
                end
            end
            else begin
                next_state = 2'b01;
                next_accu_sum = accu_sum;
                next_count = count;
                next_valid_out = 1'b0;
            end
        end
        default: begin
            next_state = 2'b00;
            next_accu_sum = 0;
            next_count = 0;
            next_valid_out = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= 2'b00;
        accu_sum <= 0;
        count <= 0;
        valid_out_reg <= 1'b0;
    end
    else begin
        state <= next_state;
        accu_sum <= next_accu_sum;
        count <= next_count;
        valid_out_reg <= next_valid_out;
    end
end

assign valid_out = valid_out_reg;
assign data_out = (valid_out_reg) ? accu_sum : 0;

endmodule