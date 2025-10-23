module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Track previous two samples (need 2 bits for 3-cycle detection)
reg [1:0] history;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new sample
        history <= {history[0], data_in};
        
        // Detect 0->1->0 pattern (history[1]=0, history[0]=1, data_in=0)
        data_out <= (history == 2'b10) && (data_in == 1'b0);
    end
end

endmodule