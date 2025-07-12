module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [15:0] shift_reg;
reg shift_reg_full;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Asynchronous reset
        shift_reg <= 16'b0;
        shift_reg_full <= 1'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (!shift_reg_full) begin
                // First byte - store in upper bits
                shift_reg[15:8] <= data_in;
                shift_reg_full <= 1'b1;
            end else begin
                // Second byte - store in lower bits and output
                shift_reg[7:0] <= data_in;
                data_out <= {shift_reg[15:8], data_in};
                valid_out <= 1'b1;
                shift_reg_full <= 1'b0;
            end
        end
    end
end

endmodule