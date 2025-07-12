module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] prev_data;  // Stores current and previous data_in values

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_data <= 2'b00;
        data_out <= 0;
    end else begin
        // Shift in new data
        prev_data <= {prev_data[0], data_in};
        
        // Detect falling edge (1->0 transition)
        data_out <= (prev_data == 2'b10);
    end
end

endmodule