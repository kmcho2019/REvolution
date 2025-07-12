module accu (
    input         clk,
    input         rst_n,
    input  [7:0]   data_in,
    input         valid_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [1:0]  state;
reg [1:0]  next_state;
reg [9:0]  accu_sum;
reg [9:0]  next_accu_sum;
reg [1:0]  cnt;
reg [1:0]  next_cnt;
reg        valid_out_reg;
reg        next_valid_out;

always @(*) begin
    next_state  = state;
    next_accu_sum = accu_sum;
    next_cnt    = cnt;
    next_valid_out = 0;

    case (state)
        2'b00: begin // idle state
            if (valid_in) begin
                next_state  = 2'b01; // transition to accumulating state
                next_accu_sum = data_in; // initialize accumulated sum
                next_cnt    = 1; // initialize counter
            end
        end
        2'b01: begin // accumulating state
            if (valid_in) begin
                next_accu_sum = accu_sum + data_in; // accumulate input data
                next_cnt    = cnt + 1; // increment counter
                if (cnt == 3) begin // if four valid input data have been received
                    next_state  = 2'b00; // transition back to idle state
                    next_valid_out = 1; // assert valid_out signal
                end
            end else begin
                next_state  = 2'b00; // transition back to idle state
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state       <= 2'b00;
        accu_sum   <= 10'd0;
        cnt        <= 2'd0;
        valid_out_reg <= 0;
    end else begin
        state       <= next_state;
        accu_sum   <= next_accu_sum;
        cnt        <= next_cnt;
        valid_out_reg <= next_valid_out;
    end
end

assign valid_out = valid_out_reg;
assign data_out  = accu_sum;

endmodule