module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for counting up, 1 for counting down

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 0;
    end
    else begin
        // Boundary detection and direction control
        if (Q == 64'h8000_0000_0000_0000) begin
            direction <= 1;  // Switch to counting down
        end
        else if (Q == 64'h0000_0000_0000_0001) begin
            direction <= 0;  // Switch to counting up
        end

        // Shift operation based on direction
        if (!direction) begin
            // Counting up: shift right with 1
            Q <= {1'b1, Q[63:1]};
        end
        else begin
            // Counting down: shift right with 0
            Q <= {1'b0, Q[63:1]};
        end
    end
end

endmodule