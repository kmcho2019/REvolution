module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg last_x;  // Stores previous value of x for edge detection
    reg toggle;  // Tracks whether we've seen the first '1' (state B)

    // Edge detection and state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            last_x <= 1'b0;
            toggle <= 1'b0;
            z <= 1'b0;
        end
        else begin
            // Detect rising edge of x when in state A (toggle=0)
            if (~toggle && (x & ~last_x)) begin
                toggle <= 1'b1;
                z <= 1'b1;
            end
            // All other cases in state B (toggle=1)
            else if (toggle) begin
                z <= ~x;
            end
            
            last_x <= x;
        end
    end

endmodule