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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state         <= 2'd0;
        sum           <= 10'd0;
        count         <= 2'd0;
        valid_out_reg <= 1'd0;
    end else begin
        state         <= next_state;
        sum           <= next_sum;
        count         <= next_count;
        valid_out_reg <= next_valid_out;
    end
end

always @(*) begin
    next_state       = state;
    next_sum         = sum;
    next_count       = count;
    next_valid_out   = 1'd0;

    case (state)
        2'd0: begin // IDLE
            if (valid_in) begin
                next_state = 2'd1;
                next_sum   = data_in;
                next_count = 2'd1;
            end
        end
        2'd1: begin // ACCUMULATE
            if (valid_in) begin
                next_sum   = sum + data_in;
                next_count = count + 1'd1;
                if (count == 2'd3) begin
                    next_state     = 2'd2;
                    next_valid_out = 1'd1;
                end
            end
        end
        2'd2: begin // OUTPUT
            next_state = 2'd0;
        end
    endcase
end

assign valid_out = valid_out_reg;
assign data_out  = sum;

endmodule