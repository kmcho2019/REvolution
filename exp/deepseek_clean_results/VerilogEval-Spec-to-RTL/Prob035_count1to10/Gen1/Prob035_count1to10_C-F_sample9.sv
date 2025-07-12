module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Parameters for maintainability
parameter START_VAL = 4'b0001;
parameter END_VAL = 4'b1010;

// Combinational next state logic
wire [3:0] next_q;
assign next_q = (q == END_VAL) ? START_VAL : (q + 1);

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        q <= START_VAL;  // Synchronous reset to 1
    end
    else begin
        q <= next_q;      // Update with pre-computed next state
    end
end

endmodule