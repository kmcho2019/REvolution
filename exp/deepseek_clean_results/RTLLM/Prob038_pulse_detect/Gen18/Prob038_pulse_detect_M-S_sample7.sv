module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data, curr_data;
reg saw_zero;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        curr_data <= 1'b0;
        saw_zero <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Shift current to previous and capture new input
        prev_data <= curr_data;
        curr_data <= data_in;
        
        // Track if we've seen a zero before the one
        if (curr_data == 1'b0)
            saw_zero <= 1'b1;
        else if (curr_data == 1'b1 && prev_data == 1'b0)
            saw_zero <= 1'b0;
            
        // Pulse detection
        if (prev_data == 1'b1 && curr_data == 1'b0 && saw_zero)
            data_out <= 1'b1;
        else
            data_out <= 1'b0;
    end
end

endmodule