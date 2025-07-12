module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state
assign next_q = (q == 4'b1010) ? 4'b0001 : q + 1;

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;
    end else begin
        q <= next_q;
    end
end

endmodule