module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] q;

    initial begin
        q = 8'h34; // Initialize q with the reset value
    end

    always @(negedge clk) begin
        if (reset) begin
            q <= 8'h34; // Reset q to 0x34
        end else begin
            q <= d; // Update q with d on the negative edge of clk
        end
    end

endmodule