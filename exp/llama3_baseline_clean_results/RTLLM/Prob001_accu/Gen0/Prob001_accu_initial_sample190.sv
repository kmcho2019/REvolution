module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [7:0] data_buf [0:3]; // Buffer to hold 4 input data
reg [1:0] counter; // Counter to keep track of the number of input data
reg [9:0] sum; // Accumulated sum
reg valid_out_reg; // Registered valid_out signal

// Reset logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 0;
        valid_out_reg <= 0;
        data_out <= 0;
    end else begin
        // Store input data in the buffer
        if (valid_in) begin
            data_buf[counter] <= data_in;
            counter <= counter + 1;
        end
        
        // Calculate the sum and output when 4 data are received
        if (counter == 4) begin
            sum <= data_buf[0] + data_buf[1] + data_buf[2] + data_buf[3];
            valid_out_reg <= 1;
            data_out <= sum;
            counter <= 0; // Reset counter
        end else begin
            valid_out_reg <= 0;
        end
    end
end

assign valid_out = valid_out_reg;

endmodule