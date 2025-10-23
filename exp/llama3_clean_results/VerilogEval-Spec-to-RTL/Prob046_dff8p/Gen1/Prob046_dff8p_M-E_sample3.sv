module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always_ff @(negedge clk) begin
    if(reset) begin
        for(int i = 0; i < 8; i++) begin
            q[i] <= 0x34[i]; // Assign the reset value bit by bit
        end
    end else begin
        q <= d;
    end
end

endmodule