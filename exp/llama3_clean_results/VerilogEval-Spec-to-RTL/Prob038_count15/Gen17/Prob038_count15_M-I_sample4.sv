module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Maintain simplicity and efficiency while considering PPA optimization
always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0 maintains clarity and good design practice
        q <= 4'd0;
    end else begin
        // Direct incrementation with potential for synthesis optimization
        q <= (q == 4'd15) ? 4'd0 : q + 1;
    end
end

endmodule