module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [2:0] pattern_buffer;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pattern_buffer <= 3'b000;
        data_out <= 1'b0;
    end else begin
        // Shift in new data and maintain 3-cycle history
        pattern_buffer <= {pattern_buffer[1:0], data_in};
        
        // Detect 010 pattern in the buffer
        data_out <= (pattern_buffer == 3'b010);
    end
end

endmodule