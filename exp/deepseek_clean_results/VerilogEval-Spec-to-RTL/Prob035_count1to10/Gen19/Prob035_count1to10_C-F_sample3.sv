module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;
wire wrap_condition = (q == 4'b1010);  // Explicit check for value 10

assign next_q = wrap_condition ? 4'b0001 :  // Wrap around at 10
                q + 4'b0001;               // Otherwise increment

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Synchronous reset to 1
    end else begin
        q <= next_q;   // Update with next state
    end
end

endmodule