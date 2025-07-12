module width_8to16 (
    input           clk,       // Clock signal
    input           rst_n,     // Active-low reset signal
    input           valid_in,  // Input signal indicating the validity of the input data
    input   [7:0]    data_in,   // 8-bit input data to be converted
    output  logic   valid_out, // Output signal indicating the validity of the output data
    output  logic [15:0] data_out  // 16-bit output data resulting from the width conversion
);

logic [7:0] data_lock;  // Register to store the first 8-bit data
logic flag;            // Flag signal to indicate whether the first data has been received

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset
        data_out <= 16'd0;
        data_lock <= 8'd0;
        flag <= 1'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;  // Default value
        if (valid_in && !flag) begin  // First valid data
            data_lock <= data_in;
            flag <= 1'b1;
        end else if (valid_in && flag) begin  // Second valid data
            data_out <= {data_lock, data_in};
            valid_out <= 1'b1;
            flag <= 1'b0;  // Reset flag
        end
    end
end

endmodule