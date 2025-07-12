module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

// Internal signals
reg [63:0] next_Q;
reg direction;  // 0 for forward (appending 1s), 1 for reverse (appending 0s)

// Stage 1: Combinational next state logic
always @(*) begin
    if (!rst_n) begin
        next_Q = 64'b0;
        direction = 1'b0;
    end else begin
        // Parallel state generation
        if (Q == 64'b0) begin
            next_Q = {63'b0, 1'b1};  // Start condition
            direction = 1'b0;
        end else if (&Q) begin
            next_Q = {1'b0, 63'b1};   // Reverse direction condition
            direction = 1'b1;
        end else begin
            // Parallel shift with direction control
            next_Q = direction ? {1'b0, Q[63:1]} : {1'b1, Q[63:1]};
        end
    end
end

// Stage 2: Sequential state update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= next_Q;
    end
end

endmodule