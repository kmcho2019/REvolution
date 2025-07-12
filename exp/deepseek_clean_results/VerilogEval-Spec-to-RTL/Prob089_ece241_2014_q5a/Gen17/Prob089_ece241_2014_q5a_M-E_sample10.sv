module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg [7:0] invert_flag = 8'b0;  // Shift register to track inversion points
    reg seen_one = 0;              // Flag indicating first '1' encountered

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 8'b0;
            seen_one <= 0;
            z <= 0;
        end else begin
            // Update shift register and flag
            invert_flag <= {invert_flag[6:0], seen_one};
            seen_one <= seen_one | x;
            
            // Compute output
            if (invert_flag[0]) begin
                z <= ~x;  // Invert bits after first '1'
            end else begin
                z <= x;   // Copy bits before first '1'
            end
        end
    end

endmodule