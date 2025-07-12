module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // States: 0 = pass through, 1 = invert
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            z <= 1'b0;
        end else begin
            case (state)
                1'b0: begin
                    z <= x;
                    state <= x; // Transition on first '1'
                end
                1'b1: begin
                    z <= ~x;   // Invert all subsequent bits
                end
            endcase
        end
    end

endmodule