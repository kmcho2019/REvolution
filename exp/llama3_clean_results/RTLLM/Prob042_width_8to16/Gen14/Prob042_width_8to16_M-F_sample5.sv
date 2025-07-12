module width_8to16(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_capture_reg;
reg [15:0] data_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_capture_reg <= 8'b0;
        valid_out <= 1'b0;
        data_out_reg <= 16'b0;
    end else begin
        if (valid_in && data_capture_reg == 8'b0) begin
            // Capture the first valid 8-bit data
            data_capture_reg <= data_in;
            valid_out <= 1'b0; // Ensure valid_out is low until a complete packet is assembled
        end else if (valid_in && data_capture_reg!= 8'b0) begin
            // Assemble the 16-bit output from the captured and new data
            data_out_reg <= {data_capture_reg, data_in};
            valid_out <= 1'b1;
            data_capture_reg <= 8'b0; // Reset the capture register
        end else begin
            valid_out <= 1'b0; // Reset valid_out if no valid input or incomplete packet
        end
    end
end

// Continuous assignment for data_out to reflect the internal register state
assign data_out = data_out_reg;

endmodule