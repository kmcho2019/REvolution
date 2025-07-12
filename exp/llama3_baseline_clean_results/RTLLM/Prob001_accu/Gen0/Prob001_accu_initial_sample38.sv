module accu(
    input           clk,
    input           rst_n,
    input   [7:0]    data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]    data_out
);

reg     [1:0]       state;
reg     [1:0]       next_state;
reg     [9:0]       sum;
reg     [9:0]       next_sum;
reg     [1:0]       count;
reg     [1:0]       next_count;
reg                 valid_out_reg;
reg                 next_valid_out;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state           <= 2'b00;
        sum             <= 10'b0;
        count           <= 2'b00;
        valid_out_reg   <= 1'b0;
    end else begin
        state           <= next_state;
        sum             <= next_sum;
        count           <= next_count;
        valid_out_reg   <= next_valid_out;
    end
end

always @(*) begin
    next_state         = state;
    next_sum           = sum;
    next_count         = count;
    next_valid_out     = 1'b0;
    
    case (state)
        2'b00: begin // idle
            if (valid_in) begin
                next_state     = 2'b01;
                next_sum       = data_in;
                next_count     = 2'b01;
            end else begin
                next_state     = 2'b00;
            end
        end
        2'b01: begin // accumulating
            if (valid_in) begin
                next_sum       = sum + data_in;
                next_count     = count + 1'b1;
                if (count == 2'b11) begin
                    next_state     = 2'b10;
                    next_valid_out = 1'b1;
                end else begin
                    next_state     = 2'b01;
                end
            end else begin
                next_state     = 2'b01;
            end
        end
        2'b10: begin // output
            next_state     = 2'b00;
        end
        default: begin
            next_state     = 2'b00;
        end
    endcase
end

assign data_out    = sum;
assign valid_out   = valid_out_reg;

endmodule