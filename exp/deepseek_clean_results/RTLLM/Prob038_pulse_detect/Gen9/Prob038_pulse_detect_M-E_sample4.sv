module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] history;  // Stores last 3 samples

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 3'b000;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new sample
        history <= {history[1:0], data_in};
        
        // Output is high when we detect 010 pattern
        data_out <= (history == 3'b010);
    end
end

endmodule