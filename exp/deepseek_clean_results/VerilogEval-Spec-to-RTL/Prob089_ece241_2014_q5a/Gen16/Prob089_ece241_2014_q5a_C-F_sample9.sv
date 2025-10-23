module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    localparam PASS = 1'b0;  // Passing bits through (before first '1')
    localparam INVERT = 1'b1; // Inverting bits (after first '1')
    
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
                default: begin
                    state <= PASS;
                    z <= x;
                end
            endcase
        end
    end

endmodule