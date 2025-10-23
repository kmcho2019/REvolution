module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Named states for readability
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
                    z <= x;  // Direct assignment for copy mode
                    if (x) state <= INVERT;  // Transition only on first '1'
                end
                INVERT: begin
                    z <= ~x;  // Direct assignment for invert mode
                end
            endcase
        end
    end

endmodule