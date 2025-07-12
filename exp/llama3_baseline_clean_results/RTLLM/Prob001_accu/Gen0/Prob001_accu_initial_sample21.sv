module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] counter; // Counter to track the number of valid inputs
reg [9:0] sum;    // Register to store the accumulated sum
reg valid_out_reg; // Register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 2'b00;
        sum <= 10'b0;
        valid_out_reg <= 1'b0;
    end else if (valid_in) begin
        if (counter == 2'b11) begin // Counter is 4, output the sum
            valid_out_reg <= 1'b1;
            sum <= sum + data_in;
            counter <= 2'b00; // Reset counter
        end else begin
            sum <= sum + data_in;
            counter <= counter + 1'b1; // Increment counter
            valid_out_reg <= 1'b0; // Reset valid_out
        end
    end else begin
        valid_out_reg <= 1'b0; // Reset valid_out when no input
    end
end

always @(*) begin
    valid_out = valid_out_reg;
    if (valid_out_reg) begin
        data_out = sum;
    end else begin
        data_out = 10'b0;
    end
end

endmodule