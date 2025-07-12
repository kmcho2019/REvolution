module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] history;  // Stores previous two states [prev_prev, prev]

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b00;
        data_out <= 1'b0;
    end else begin
        // Check for 0->1->0 pattern (current=0, history=01)
        data_out <= (data_in == 1'b0) && (history == 2'b01);
        
        // Update history shift register
        history <= {history[0], data_in};
    end
end

endmodule