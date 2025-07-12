module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;  // Stores previous data_in value
reg expect_fall; // Flag indicating we're expecting a falling edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        expect_fall <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Update previous data
        prev_data <= data_in;
        
        // Detect rising edge (0->1)
        if (!prev_data && data_in) begin
            expect_fall <= 1'b1;
        end
        
        // Generate output and clear flag on falling edge (1->0)
        data_out <= expect_fall && prev_data && !data_in;
        if (data_out) begin
            expect_fall <= 1'b0;
        end
    end
end

endmodule