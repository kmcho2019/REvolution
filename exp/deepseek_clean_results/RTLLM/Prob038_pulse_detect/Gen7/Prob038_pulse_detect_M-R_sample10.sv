module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg sample_0, sample_1, sample_2;

// Shift register implementation with explicit bits
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sample_0 <= 1'b0;
        sample_1 <= 1'b0;
        sample_2 <= 1'b0;
    end else begin
        sample_2 <= sample_1;
        sample_1 <= sample_0;
        sample_0 <= data_in;
    end
end

// Combinational output using continuous assign
assign data_out = (!sample_2 & sample_1 & !sample_0);

endmodule