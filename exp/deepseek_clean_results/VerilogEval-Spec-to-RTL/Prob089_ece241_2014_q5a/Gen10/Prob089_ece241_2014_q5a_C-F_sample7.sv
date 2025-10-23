module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Named states for clarity while maintaining minimal encoding
    parameter COPY = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            case (state)
                COPY: begin
                    z <= x;
                    state <= x ? INVERT : COPY;  // Direct transition when x=1
                end
                INVERT: begin
                    z <= ~x;  // Stay in INVERT state
                end
            endcase
        end
    end

endmodule