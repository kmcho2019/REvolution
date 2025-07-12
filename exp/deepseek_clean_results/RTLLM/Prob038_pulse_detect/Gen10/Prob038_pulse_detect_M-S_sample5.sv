module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev1, prev0;  // Stores previous two values

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev1 <= 1'b0;
        prev0 <= 1'b0;
        data_out <= 1'b0;
    end else begin
        // Shift in new data
        prev1 <= prev0;
        prev0 <= data_in;
        
        // Detect 0-1-0 pattern
        data_out <= ~data_in & prev0 & ~prev1;
    end
end

endmodule