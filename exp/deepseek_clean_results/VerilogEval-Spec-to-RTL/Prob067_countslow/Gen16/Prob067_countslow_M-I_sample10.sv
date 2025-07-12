module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

reg reset_condition;

// Combinational next state logic (simplified)
wire [3:0] next_q = reset_condition ? 4'b0000 : (q + 1'b1);

// Sequential logic
always @(posedge clk) begin
    // Register the reset condition detection
    reset_condition <= (q[3] & q[0]);
    
    if (reset) begin
        q <= 4'b0000;
    end
    else if (slowena) begin
        q <= next_q;
    end
end

endmodule