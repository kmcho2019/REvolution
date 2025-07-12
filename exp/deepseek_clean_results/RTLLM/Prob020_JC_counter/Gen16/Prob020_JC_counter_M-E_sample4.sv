module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg direction;  // 0 for right-shift-0, 1 for right-shift-1

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        direction <= 1'b0;  // Start with shift-0 direction
    end else begin
        // Perform shift based on current direction
        Q <= {direction, Q[63:1]};
        
        // Update direction when reaching terminal states
        case (Q)
            64'h0000000000000000: direction <= 1'b1;
            64'hFFFFFFFFFFFFFFFF: direction <= 1'b0;
            default: direction <= direction;
        endcase
    end
end

endmodule