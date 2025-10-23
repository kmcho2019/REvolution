module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

// Directly implement the D flip-flop behavior with active high synchronous reset
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset the flip-flop to 0 on the positive edge of the clock when reset is high
        q <= 8'b0;
    end else begin
        // Otherwise, load the input 'd' into the flip-flop on the positive edge of the clock
        q <= d;
    end
end

endmodule