module accu (
    input        clk,        // Clock input for synchronization
    input        rst_n,      // Active-low reset signal
    input  [7:0] data_in,    // 8-bit input data for addition
    input        valid_in,   // Input signal indicating readiness for new data
    output       valid_out,  // Output signal indicating when 4 input data accumulation is reached
    output [9:0] data_out    // 10-bit output data representing the accumulated sum
);

reg [9:0] sum;  // Register to store the accumulated sum
reg [1:0] cnt;  // Counter to keep track of the number of valid input data received
reg         valid_out_reg;  // Register to store the valid_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the module when rst_n is low
        sum <= 10'd0;
        cnt <= 2'd0;
        valid_out_reg <= 1'b0;
    end else begin
        // Accumulate the input data when valid_in is 1
        if (valid_in) begin
            sum <= sum + data_in;
            cnt <= cnt + 1;
        end
        
        // Output the accumulated sum and set valid_out to 1 when 4 input data are received
        if (cnt == 4'd3) begin
            valid_out_reg <= 1'b1;
        end else begin
            valid_out_reg <= 1'b0;
        end
        
        // Reset the counter and sum when valid_out is 1
        if (valid_out_reg) begin
            cnt <= 2'd0;
            sum <= 10'd0;
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = sum;

endmodule