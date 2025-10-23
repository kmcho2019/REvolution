module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] data_in_ff;  // 3-stage shift register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_in_ff <= 3'b000;
        data_out <= 1'b0;
    end else begin
        // Shift in new data
        data_in_ff <= {data_in_ff[1:0], data_in};
        
        // Detect 0->1->0 pattern
        data_out <= (data_in_ff == 3'b010);
    end
end

endmodule