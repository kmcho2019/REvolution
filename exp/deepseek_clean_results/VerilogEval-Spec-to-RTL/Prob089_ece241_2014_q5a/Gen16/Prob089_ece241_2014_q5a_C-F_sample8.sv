module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Clear state definitions
    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
            z <= 1'b0;
        end else begin
            case (state)
                PASS: begin
                    z <= x;
                    if (x) state <= INVERT;
                end
                INVERT: begin
                    z <= ~x;
                end
            endcase
        end
    end

endmodule