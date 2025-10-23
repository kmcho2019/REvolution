module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;  // Stores previous data_in value
reg flag;       // Indicates we've seen a rising edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        flag <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Default output
        data_out <= 1'b0;
        
        // Detect rising edge (0->1)
        if (!prev_data && data_in) begin
            flag <= 1'b1;
        end
        // Detect falling edge (1->0) with flag set
        else if (prev_data && !data_in && flag) begin
            data_out <= 1'b1;
            flag <= 1'b0;
        end
        
        // Update previous data
        prev_data <= data_in;
    end
end

endmodule