module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] data_history;  // Stores current and previous two data_in values

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_history <= 3'b000;
        data_out <= 0;
    end else begin
        // Shift in new data
        data_history <= {data_history[1:0], data_in};
        
        // Detect full pulse sequence (0->1->0)
        data_out <= (data_history == 3'b010);
    end
end

endmodule