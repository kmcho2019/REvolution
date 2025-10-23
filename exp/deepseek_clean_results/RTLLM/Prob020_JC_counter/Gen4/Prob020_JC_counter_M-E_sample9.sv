module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 = filling (adding 1s), 1 = emptying (adding 0s)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 1'b0;  // Start in filling phase
    end else begin
        // Check for phase change conditions
        if (direction == 1'b0 && &Q[62:0]) begin
            // Transition from filling to emptying when all but MSB are 1
            direction <= 1'b1;
            Q <= {Q[62:0], 1'b1};  // Complete the fill
        end else if (direction == 1'b1 && ~|Q[62:0]) begin
            // Transition from emptying to filling when all but MSB are 0
            direction <= 1'b0;
            Q <= {Q[62:0], 1'b0};  // Complete the empty
        end else begin
            // Normal operation - shift and add new bit based on direction
            Q <= {direction ? 1'b0 : 1'b1, Q[63:1]};
        end
    end
end

endmodule