module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen; // Tracks if we've seen the first '1'
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen <= 1'b0;
            z <= 1'b0;
        end else begin
            case (seen)
                1'b0: begin
                    z <= x;
                    seen <= x; // Transition to invert state after first '1'
                end
                1'b1: z <= ~x; // Invert all subsequent bits
            endcase
        end
    end

endmodule