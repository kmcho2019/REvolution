module width_8to16(
    input           clk,
    input           rst_n,
    input           valid_in,
    input   [7:0]   data_in,
    output          valid_out,
    output  [15:0]  data_out
);

reg [7:0] buffer1;  // First 8-bit buffer
reg [7:0] buffer2;  // Second 8-bit buffer
reg        buffer1_valid;  // Valid signal for buffer1
reg        buffer2_valid;  // Valid signal for buffer2
reg        valid_out_reg;  // Output valid signal register
reg [15:0] data_out_reg;  // 16-bit output data register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        buffer1 <= 8'd0;  // Reset buffer1
        buffer2 <= 8'd0;  // Reset buffer2
        buffer1_valid <= 1'b0;  // Reset buffer1 valid signal
        buffer2_valid <= 1'b0;  // Reset buffer2 valid signal
        valid_out_reg <= 1'b0;  // Reset output valid signal
        data_out_reg <= 16'd0;  // Reset output data
    end else begin
        if (valid_in) begin
            if (!buffer1_valid) begin
                buffer1 <= data_in;  // Store data in buffer1
                buffer1_valid <= 1'b1;  // Set buffer1 valid signal
            end else if (!buffer2_valid) begin
                buffer2 <= data_in;  // Store data in buffer2
                buffer2_valid <= 1'b1;  // Set buffer2 valid signal
            end
        end

        if (buffer1_valid && buffer2_valid) begin
            data_out_reg <= {buffer2, buffer1};  // Concatenate data from buffers
            valid_out_reg <= 1'b1;  // Set output valid signal
            buffer1_valid <= 1'b0;  // Reset buffer1 valid signal
            buffer2_valid <= 1'b0;  // Reset buffer2 valid signal
        end
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule