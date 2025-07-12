module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

reg [1:0] state; // [0] = previous, [1] = current

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 2'b00;
    end
    else begin
        state <= {state[0], data_in};
    end
end

// Pulse detected when previous=1 and current=0 (after seeing 0->1)
assign data_out = (state == 2'b10);

endmodule