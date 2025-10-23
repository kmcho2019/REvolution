module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define the reset value as a parameter
parameter RESET_VALUE = 8'h34;

// Generate 8 D flip-flops with active high synchronous reset
always @(posedge ~clk) begin
    if (reset) begin
        for (int i = 0; i < 8; i++) begin
            q[i] <= RESET_VALUE[i];
        end
    end else begin
        q <= d;
    end
end

endmodule