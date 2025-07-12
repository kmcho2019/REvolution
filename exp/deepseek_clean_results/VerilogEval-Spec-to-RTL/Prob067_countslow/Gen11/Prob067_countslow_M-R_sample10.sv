module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

wire [3:0] next_q;

// Combinational logic for next state
assign next_q = (q[3] & q[0]) ? 4'b0000 :  // Reset to 0 after 9
                (q + 4'b0001);             // Otherwise increment

// Sequential logic with synchronous reset and enable
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        q <= next_q;
    end
end

endmodule