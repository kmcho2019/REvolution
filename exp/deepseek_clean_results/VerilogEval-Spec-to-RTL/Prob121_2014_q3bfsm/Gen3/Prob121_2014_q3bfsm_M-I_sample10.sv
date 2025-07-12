module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] y; // Current state register
    wire clk_enable = (y != (x ? 3'b001 : 3'b000)) || 
                     (y != (x ? 3'b100 : 3'b001)) ||
                     (y != (x ? 3'b001 : 3'b010)) ||
                     (y != (x ? 3'b010 : 3'b001)) ||
                     (y != (x ? 3'b100 : 3'b011));

    // State transitions with clock gating
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000; // Synchronous reset to state 000
            z <= 1'b0;
        end else if (clk_enable) begin
            case (y)
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
            endcase
            
            // Registered output
            z <= (y == 3'b011 || y == 3'b100);
        end
    end

endmodule