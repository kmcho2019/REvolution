module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for increment (shift in 1s), 1 for decrement (shift in 0s)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 0;
    end
    else begin
        // Terminal state detection
        if (Q == 64'hFFFFFFFFFFFFFFFF) begin
            direction <= 1;  // Switch to decrement mode
            Q <= {1'b0, Q[63:1]};
        end
        else if (Q == 64'b0) begin
            direction <= 0;  // Switch to increment mode
            Q <= {1'b1, Q[63:1]};
        end
        else begin
            // Normal operation - shift based on current direction
            Q <= {~direction, Q[63:1]};
        end
    end
end

endmodule