module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state;

// Sequential logic with synchronous reset
always @(posedge clk) begin
    if (a) begin
        state <= 3'd4;  // reset to 4 when a=1
    end else begin
        state <= (state == 3'd6) ? 3'd0 : state + 3'd1;
    end
end

// Continuous output assignment
assign q = state;

endmodule