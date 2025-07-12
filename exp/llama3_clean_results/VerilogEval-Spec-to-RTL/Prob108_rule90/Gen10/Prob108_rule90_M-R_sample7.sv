module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg; // Register to store the current state

always @(posedge clk) begin
    if (load) begin
        q_reg <= data; // Load input data
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, right;
            if (i == 0) begin
                left = 1'b0; // Left boundary
                right = q_reg[i + 1];
            end else if (i == 511) begin
                left = q_reg[i - 1];
                right = 1'b0; // Right boundary
            end else begin
                left = q_reg[i - 1];
                right = q_reg[i + 1];
            end
            q_reg[i] <= left ^ right; // Rule 90: XOR of left and right
        end
    end
end

assign q = q_reg; // Output the current state

endmodule