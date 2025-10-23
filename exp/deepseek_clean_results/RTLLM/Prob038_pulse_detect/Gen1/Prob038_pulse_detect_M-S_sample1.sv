module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] history;  // Stores previous two values (history[1] is oldest)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b00;
        data_out <= 1'b0;
    end
    else begin
        // Shift in new value
        history <= {history[0], data_in};
        
        // Pulse detected when we see 0->1->0 sequence
        data_out <= (history == 2'b10) && (data_in == 1'b0);
    end
end

endmodule