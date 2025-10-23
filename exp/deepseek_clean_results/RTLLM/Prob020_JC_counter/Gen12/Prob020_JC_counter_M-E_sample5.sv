module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for right shift (increment), 1 for left shift (decrement)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 0;
    end else begin
        if (direction == 0) begin
            // Right shift mode (incrementing phase)
            Q <= {1'b1, Q[63:1]};
            if (Q == 64'hFFFFFFFF_FFFFFFFF) begin
                direction <= 1;
            end
        end else begin
            // Left shift mode (decrementing phase)
            Q <= {Q[62:0], 1'b0};
            if (Q == 64'b0) begin
                direction <= 0;
            end
        end
    end
end

endmodule