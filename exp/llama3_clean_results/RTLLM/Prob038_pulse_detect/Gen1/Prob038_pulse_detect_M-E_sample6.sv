module pulse_detect (
    input           clk,
    input           rst_n,
    input           data_in,
    output          data_out
);

reg [2:0] shift_reg;
reg [2:0] template;
reg data_out_reg;

assign template = 3'b010; // Expected pulse pattern

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset condition
        shift_reg <= 3'b000;
        data_out_reg <= 1'b0;
    end else begin
        // Shift input data into shift register
        shift_reg <= {data_in, shift_reg[2:1]};
        
        // Check if shifted values match the expected pulse pattern
        if (shift_reg == template) begin
            data_out_reg <= 1'b1;
        end else begin
            data_out_reg <= 1'b0;
        end
    end
end

assign data_out = data_out_reg;

endmodule