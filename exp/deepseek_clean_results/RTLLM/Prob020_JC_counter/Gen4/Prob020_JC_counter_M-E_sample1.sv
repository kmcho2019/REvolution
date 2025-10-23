module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 = increment (adding 1s), 1 = decrement (adding 0s)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 1'b0;  // Start in increment mode
    end else begin
        // Check for state transitions
        if (direction == 1'b0) begin
            if (&Q) begin  // All 1s - switch to decrement
                direction <= 1'b1;
                Q <= {1'b0, {63{1'b1}}};  // First decrement state
            end else begin
                Q <= {({64{1'b1}} << (64 - $countones(Q) - 1));
            end
        end else begin
            if (|Q == 1'b0) begin  // All 0s - switch to increment
                direction <= 1'b0;
                Q <= 64'h8000_0000_0000_0000;  // First increment state
            end else begin
                Q <= {({64{1'b0}} | ({64{1'b1}} >> (64 - $countones(~Q))));
            end
        end
    end
end

// Helper function to count ones (synthesizable in modern tools)
function integer $countones(input [63:0] val);
    integer i;
    begin
        $countones = 0;
        for (i = 0; i < 64; i = i + 1)
            if (val[i]) $countones = $countones + 1;
    end
endfunction

endmodule