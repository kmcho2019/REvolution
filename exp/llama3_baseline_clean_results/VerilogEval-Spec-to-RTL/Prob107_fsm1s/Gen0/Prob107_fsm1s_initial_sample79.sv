module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg s; // State register
wire next_s; // Next state logic

// Next state logic
assign next_s = (s && !in) || (!s && !in);

// Output logic
assign out = s;

// State register with reset
always @(posedge clk) begin
    if(reset) begin
        s <= 1; // Reset to state B (out=1)
    end else begin
        s <= next_s;
    end
end

endmodule