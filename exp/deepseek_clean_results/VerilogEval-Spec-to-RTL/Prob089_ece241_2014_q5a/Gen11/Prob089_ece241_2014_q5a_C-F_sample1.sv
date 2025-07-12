module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Optimized state definitions
    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
            z <= 1'b0;
        end
        else case (state)
            PASS: begin
                z <= x;
                state <= x ? INVERT : PASS;
            end
            INVERT: begin
                z <= ~x;
                // State remains INVERT once entered
            end
        endcase
    end

endmodule