module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev_data;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Pulse detected when current=0 and previous=1
        data_out <= ~data_in & prev_data;
        
        // Store current value for next cycle
        prev_data <= data_in;
    end
end

endmodule