module accu (
    input           clk,
    input           rst_n,
    input   [7:0]   data_in,
    input           valid_in,
    output          valid_out,
    output  [9:0]   data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg [1:0] counter;
reg [1:0] next_counter;
reg [9:0] sum;
reg [9:0] next_sum;
reg       valid_out_reg;
reg       next_valid_out;

always @(*) begin
    next_state = state;
    next_counter = counter;
    next_sum = sum;
    next_valid_out = 0;

    case(state)
        2'b00: begin // IDLE state
            if(valid_in) begin
                next_state = 2'b01; // transition to ACCUMULATE state
                next_counter = 1;
                next_sum = data_in;
            end
        end
        2'b01: begin // ACCUMULATE state
            if(valid_in) begin
                next_counter = counter + 1;
                next_sum = sum + data_in;
            end
            if(counter == 4) begin
                next_state = 2'b00; // transition back to IDLE state
                next_valid_out = 1;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        state <= 2'b00;
        counter <= 2'b00;
        sum <= 10'd0;
        valid_out_reg <= 0;
    end else begin
        state <= next_state;
        counter <= next_counter;
        sum <= next_sum;
        valid_out_reg <= next_valid_out;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule