module TopModule(
    input clk,
    input d,
    output reg q
);
    // Adding a reset condition for completeness, assuming an active high reset.
    // This can be adjusted based on specific design requirements.
    reg reset;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0; // Reset q to 0 on reset
        end else begin
            q <= d; // Assign d to q on the positive edge of clk
        end
    end
endmodule