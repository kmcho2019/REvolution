module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] q_next;

// Combinational logic for next state
assign q_next = q + 1'b1;

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0;
    end
    else begin
        q <= q_next;
    end
end

endmodule