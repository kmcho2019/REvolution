module width_8to16(
    input clk,         // Clock signal
    input rst_n,       // Active-low reset signal
    input valid_in,    // Input signal indicating the validity of the input data
    input [7:0] data_in, // 8-bit input data to be converted
    output valid_out,  // Output signal indicating the validity of the output data
    output [15:0] data_out  // 16-bit output data resulting from the width conversion
);

reg [7:0] data_lock;  // Register to store the first valid data
reg flag;            // Flag signal to track the reception of the first valid data
reg [15:0] data_out_reg;  // Register to store the output data

// Initialize the flag signal and data_out_reg on reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        flag <= 1'b0;
        data_out_reg <= 16'd0;
    end
    else begin
        // Update the flag signal and data_lock register based on the input validity
        if (valid_in && ~flag) begin
            data_lock <= data_in;
            flag <= 1'b1;
        end
        // Update the data_out_reg register when both valid input data are received
        else if (valid_in && flag) begin
            data_out_reg <= {data_lock, data_in};
            flag <= 1'b0;
        end
    end
end

// Assign the output signals
assign valid_out = (flag == 1'b0 && data_out_reg != 16'd0);
assign data_out = data_out_reg;

endmodule