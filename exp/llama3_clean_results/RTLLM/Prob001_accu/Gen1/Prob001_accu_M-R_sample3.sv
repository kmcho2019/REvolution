module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [1:0] counter;
reg [9:0] sum;

// Combinational logic to determine next state and output
wire next_valid_out;
wire [9:0] next_data_out;
wire [1:0] next_counter;
wire [9:0] next_sum;

assign next_valid_out = (counter == 2'b11 && valid_in) ? 1'b1 : 1'b0;
assign next_data_out = (counter == 2'b11 && valid_in) ? sum + data_in : 10'b0;
assign next_counter = (counter == 2'b11 && valid_in) ? 2'b00 : (valid_in ? counter + 1'b1 : counter);
assign next_sum = (counter == 2'b11 && valid_in) ? 10'b0 : (valid_in ? sum + data_in : sum);

// Sequential logic to update state and output on clock edge
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        sum <= 10'b0;
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end else begin
        counter <= next_counter;
        sum <= next_sum;
        valid_out <= next_valid_out;
        data_out <= next_data_out;
    end
end

endmodule