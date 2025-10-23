module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] history;  // Stores previous two data_in values

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b00;
        data_out <= 0;
    end else begin
        // Shift in new data and store previous two values
        history <= {history[0], data_in};
        
        // Detect full pulse sequence (0->1->0)
        // history[1] is data_in two cycles ago
        // history[0] is data_in one cycle ago
        // data_in is current value
        data_out <= (history == 2'b01) && !data_in;
    end
end

endmodule