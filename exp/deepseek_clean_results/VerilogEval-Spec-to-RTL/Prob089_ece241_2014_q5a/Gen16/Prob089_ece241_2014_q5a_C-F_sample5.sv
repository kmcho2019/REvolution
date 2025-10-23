module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions with descriptive names
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            case (state)
                COPY: begin
                    z <= x;
                    state <= x ? INVERT : COPY;  // Transition only on first '1'
                end
                INVERT: begin
                    z <= ~x;  // Direct inversion for power efficiency
                    state <= INVERT;  // Explicitly maintain state
                end
                default: begin  // Safety case for synthesis
                    state <= COPY;
                    z <= x;
                end
            endcase
        end
    end

endmodule