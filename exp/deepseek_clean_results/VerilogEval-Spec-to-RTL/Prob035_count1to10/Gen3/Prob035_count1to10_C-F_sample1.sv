module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Parameters for maintainability and flexibility
parameter START_VAL = 4'b0001;
parameter END_VAL   = 4'b1010;

// Combinational next state logic
wire [3:0] next_q = (q == END_VAL) ? START_VAL : q + 1'b1;

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (reset) begin
        q <= START_VAL;
    end else begin
        q <= next_q;
    end
end

endmodule