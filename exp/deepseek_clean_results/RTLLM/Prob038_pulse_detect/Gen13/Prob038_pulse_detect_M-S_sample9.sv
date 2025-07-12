module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_was_1;  // Stores whether previous sample was 1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_was_1 <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Output is 1 when we see a falling edge (current=0 after prev=1)
        data_out <= prev_was_1 && !data_in;
        
        // Update previous value tracker
        prev_was_1 <= data_in;
    end
end

endmodule