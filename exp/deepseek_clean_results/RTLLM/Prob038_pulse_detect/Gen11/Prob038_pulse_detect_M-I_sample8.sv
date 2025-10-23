module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] history_reg;
reg prev_data_in;
wire enable = (data_in != prev_data_in);  // Only update on input changes

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history_reg <= 3'b000;
        prev_data_in <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        prev_data_in <= data_in;
        
        if (enable) begin
            history_reg <= {history_reg[1:0], data_in};
        end
        
        // Registered output for better timing
        data_out <= (history_reg == 3'b010);
    end
end

endmodule