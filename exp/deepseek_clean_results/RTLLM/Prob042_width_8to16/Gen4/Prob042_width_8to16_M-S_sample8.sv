module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [7:0] data_reg;
reg flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg <= 8'b0;
        flag <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        valid_out <= 1'b0;  // Default output
        
        if (valid_in) begin
            if (!flag) begin
                // Store first byte
                data_reg <= data_in;
                flag <= 1'b1;
            end else begin
                // Output concatenated data
                data_out <= {data_reg, data_in};
                valid_out <= 1'b1;
                flag <= 1'b0;
            end
        end
    end
end

endmodule