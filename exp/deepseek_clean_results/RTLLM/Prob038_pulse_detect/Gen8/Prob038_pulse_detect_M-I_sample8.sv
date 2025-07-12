module pulse_detect #(
    parameter PATTERN = 3'b010  // Default detect 0->1->0 pattern
)(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] data_history;  // 2-bit shift register [prev_data, prev_prev_data]
wire clk_enable;

// Clock gating: only enable when input changes or we might have a pulse
assign clk_enable = (data_in != data_history[0]) || 
                   (data_history == PATTERN[2:1]);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_history <= 2'b00;
        data_out <= 1'b0;
    end else if (clk_enable) begin
        // Check for pattern match (current input is last bit of pattern)
        data_out <= ({data_in, data_history} == PATTERN);
        
        // Shift register update
        data_history <= {data_in, data_history[1]};
    end
end

endmodule