module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_lock;  // Register to store the first 8-bit data input
reg flag;             // Flag to track whether the first 8-bit data has arrived

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset all registers and signals
        valid_out <= 1'b0;
        data_out <= 16'd0;
        data_lock <= 8'd0;
        flag <= 1'b0;
    end else begin
        if (valid_in) begin
            if (~flag) begin
                // Store the first 8-bit data input and set the flag
                data_lock <= data_in;
                flag <= 1'b1;
            end else begin
                // Concatenate the stored data and the new data input
                data_out <= {data_lock, data_in};
                valid_out <= 1'b1;
                flag <= 1'b0;  // Reset the flag for the next pair of data inputs
            end
        end else begin
            valid_out <= 1'b0;  // Reset valid_out when input is not valid
        end
    end
end

endmodule