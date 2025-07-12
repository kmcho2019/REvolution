module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

// Register to store the first 8-bit data
reg [7:0]  data_lock;  

// Flag to indicate whether the first data has been received
reg        flag;       

// Register for the 16-bit output data
reg [15:0] data_out_reg;  

// Register for the valid_out signal
reg        valid_out_reg;  

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset the registers and flag
        data_lock  <= 8'd0;
        flag       <= 1'b0;
        data_out_reg <= 16'd0;
        valid_out_reg <= 1'b0;
    end else begin
        // If the input data is valid and it's the first data, store it and set the flag
        if (valid_in &&!flag) begin
            data_lock  <= data_in;
            flag       <= 1'b1;
            valid_out_reg <= 1'b0; // Reset valid_out when new data is stored
        end 
        // If the input data is valid and it's the second data, concatenate the stored data with the new data and update the output
        else if (valid_in && flag) begin
            data_out_reg <= {data_lock, data_in};
            valid_out_reg <= 1'b1;
            flag       <= 1'b0;  // Reset the flag
        end 
        // If the input data is not valid, do nothing but keep the previous state
        else begin
            // Keep the previous state
        end
    end
end

// Continuous assignment for the output signals
assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule