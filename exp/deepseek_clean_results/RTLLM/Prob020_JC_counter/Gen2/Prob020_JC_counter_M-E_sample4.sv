module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for counting up (shifting in 1s), 1 for counting down (shifting in 0s)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 1'b0;  // Start counting up
    end
    else begin
        // Detect terminal states
        if (Q == 64'hFFFFFFFFFFFFFFFF) begin
            direction <= 1'b1;  // Switch to counting down
        end
        else if (Q == 64'h0) begin
            direction <= 1'b0;   // Switch to counting up
        end

        // Shift operation with direction control
        if (direction) begin
            Q <= {1'b0, Q[63:1]};  // Counting down
        end
        else begin
            Q <= {1'b1, Q[63:1]};  // Counting up
        end
    end
end

endmodule