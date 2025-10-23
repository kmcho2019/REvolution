module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State tracking: Have we seen the first '1' yet?
    reg seen_one;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset state: waiting for first '1'
            seen_one <= 1'b0;
            z <= 1'b0;
        end else begin
            case (seen_one)
                1'b0: begin
                    // COPY phase: output bits as-is until first '1'
                    z <= x;
                    seen_one <= x;  // Transition to INVERT phase when we see '1'
                end
                1'b1: begin
                    // INVERT phase: output inverted bits
                    z <= ~x;
                end
                default: begin
                    // Safety case (should never occur)
                    seen_one <= 1'b0;
                    z <= x;
                end
            endcase
        end
    end

endmodule