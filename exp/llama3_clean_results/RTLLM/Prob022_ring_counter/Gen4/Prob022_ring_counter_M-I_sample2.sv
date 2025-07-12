module ring_counter(
    input clk,
    input reset,
    output reg [7:0] out
);

always @(posedge clk or posedge reset) begin
    if(reset) begin
        // Initialize the output to the starting state
        out <= 8'b0000_0001;
    end else begin
        // Perform a circular right shift using a temporary variable
        reg [7:0] temp_out;
        temp_out[7] = out[0];
        temp_out[6:0] = out[7:1];
        out <= temp_out;
    end
end

endmodule