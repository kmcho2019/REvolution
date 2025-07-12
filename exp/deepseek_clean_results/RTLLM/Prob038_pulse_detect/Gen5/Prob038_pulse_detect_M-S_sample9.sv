module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg prev1, prev2;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        {prev2, prev1, data_out} <= 3'b000;
    end else begin
        prev2 <= prev1;
        prev1 <= data_in;
        data_out <= prev2 & ~prev1 & ~data_in;
    end
end

endmodule