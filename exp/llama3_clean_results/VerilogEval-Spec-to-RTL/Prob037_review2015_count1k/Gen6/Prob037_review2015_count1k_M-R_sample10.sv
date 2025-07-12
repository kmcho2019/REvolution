module TopModule(
    input clk,
    input reset,
    output reg [9:0] q
);

// Combinational logic to determine the next state
always @(posedge clk) begin
    reg [9:0] next_q;
    assign next_q = (q == 10'd999) ? 10'd0 : q + 10'd1;
    
    if (reset) begin
        // Reset the counter to 0
        q <= 10'd0;
    end else begin
        // Update the counter's state
        q <= next_q;
    end
end

endmodule