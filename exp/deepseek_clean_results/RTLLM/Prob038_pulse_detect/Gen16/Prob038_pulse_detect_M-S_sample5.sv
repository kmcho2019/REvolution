module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg saw_rise;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        saw_rise <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Track if we saw a rising edge last cycle
        saw_rise <= ~data_in & data_in;  // Equivalent to detecting 0->1
        
        // Pulse when we see falling edge (1->0) after a rise
        data_out <= saw_rise & data_in & ~data_in;  // Equivalent to detecting 1->0 after rise
    end
end

endmodule