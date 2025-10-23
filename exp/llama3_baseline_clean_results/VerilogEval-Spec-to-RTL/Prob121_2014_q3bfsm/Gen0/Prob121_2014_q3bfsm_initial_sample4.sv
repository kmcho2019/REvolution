module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

reg [2:0] y; // Current state

always @(posedge clk) begin
    if (reset) begin
        // Synchronous active high reset
        y <= 3'd0; // Reset to state 000
    end else begin
        case (y)
            3'd0: y <= x ? 3'd1 : 3'd0;
            3'd1: y <= x ? 3'd4 : 3'd1;
            3'd2: y <= x ? 3'd1 : 3'd2;
            3'd3: y <= x ? 3'd2 : 3'd1;
            3'd4: y <= x ? 3'd4 : 3'd3;
            default: y <= 3'd0; // Default state
        endcase
    end
end

always @(posedge clk) begin
    case (y)
        3'd0: z <= 1'd0;
        3'd1: z <= 1'd0;
        3'd2: z <= 1'd0;
        3'd3: z <= x ? 1'd1 : 1'd1;
        3'd4: z <= x ? 1'd1 : 1'd1;
        default: z <= 1'd0; // Default output
    endcase
end

endmodule