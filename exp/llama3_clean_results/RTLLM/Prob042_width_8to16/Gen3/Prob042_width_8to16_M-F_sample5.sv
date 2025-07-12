module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0]  data_lock;  // Register to store the first 8-bit data
reg        flag;      // Flag to indicate if the first data has been stored
reg [15:0] data_out_reg;  // Register for the 16-bit output data
reg        valid_out_reg; // Register for the valid output signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers to their initial values
        data_lock  <= 8'd0;
        flag       <= 1'b0;
        data_out_reg <= 16'd0;
        valid_out_reg <= 1'b0;
    end else begin
        // Default values for the registers
        data_lock  <= data_lock;
        flag       <= flag;
        data_out_reg <= 16'd0; // Default: do not output unless valid
        valid_out_reg <= 1'b0; // Default: output not valid unless set
        
        if (valid_in) begin
            if (!flag) begin
                // Store the first 8-bit data and set the flag
                data_lock  <= data_in;
                flag       <= 1'b1;
            end else begin
                // Concatenate the stored data with the new data and reset the flag
                data_out_reg <= {data_lock, data_in};
                valid_out_reg <= 1'b1;
                flag       <= 1'b0;
            end
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out  = data_out_reg;

endmodule