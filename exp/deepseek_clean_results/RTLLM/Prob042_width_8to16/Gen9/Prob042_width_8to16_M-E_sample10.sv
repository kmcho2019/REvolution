module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg buffer_sel;  // Selects which buffer is active
reg [7:0] buffer_A, buffer_B;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        buffer_sel <= 1'b0;
        buffer_A <= 8'b0;
        buffer_B <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default no valid output
        
        if (valid_in) begin
            if (!buffer_sel) begin
                // Store in buffer A and toggle selector
                buffer_A <= data_in;
                buffer_sel <= 1'b1;
            end else begin
                // Store in buffer B, output concatenated data, and toggle selector
                buffer_B <= data_in;
                data_out <= {buffer_A, data_in};
                valid_out <= 1'b1;
                buffer_sel <= 1'b0;
            end
        end
    end
end

endmodule