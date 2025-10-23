module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg saw_rise;  // flag indicating we saw a rising edge

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        saw_rise <= 1'b0;
        data_out <= 1'b0;
    end
    else begin
        // Detect falling edge when we've seen a rise
        data_out <= saw_rise & ~data_in;
        
        // Update rise detection flag
        if (~saw_rise & data_in)  // 0->1 transition
            saw_rise <= 1'b1;
        else if (saw_rise & ~data_in)  // 1->0 transition
            saw_rise <= 1'b0;
    end
end

endmodule