module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] data_history;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_history <= 2'b00;
        data_out <= 1'b0;
    end else begin
        // Shift in new data
        data_history <= {data_history[0], data_in};
        
        // Detect 0->1->0 pattern (data_history was 01, current is 0)
        data_out <= (data_history == 2'b01) && !data_in;
    end
end

endmodule