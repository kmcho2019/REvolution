module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg [9:0] sum;
reg [9:0] next_sum;
reg valid_out_reg;
reg [1:0] counter;
reg [1:0] next_counter;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
        counter <= 2'b00;
    end else begin
        state <= next_state;
        sum <= next_sum;
        valid_out_reg <= 1'b0;
        counter <= next_counter;
    end
end

always @(*) begin
    next_state = state;
    next_sum = sum;
    next_counter = counter;
    
    case(state)
        2'b00: begin
            if (valid_in) begin
                next_state = 2'b01;
                next_sum = data_in;
                next_counter = 2'b01;
            end
        end
        2'b01: begin
            if (valid_in) begin
                next_state = 2'b01;
                next_sum = sum + data_in;
                next_counter = counter + 1'b1;
            end
        end
        default: begin
            if (valid_in) begin
                next_state = 2'b01;
                next_sum = sum + data_in;
                next_counter = counter + 1'b1;
            end
            if (counter == 2'b11) begin
                next_state = 2'b10;
                valid_out_reg = 1'b1;
            end
        end
    endcase
    
    if (counter == 2'b11) begin
        next_state = 2'b00;
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule