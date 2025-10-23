module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // Descriptive state names with minimal encoding
    localparam PASS = 1'b0;    // Passing bits through
    localparam FLIP = 1'b1;    // Flipping all subsequent bits

    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;     // Reset to initial state
            z <= 1'b0;         // Clear output
        end else begin
            case (state)
                PASS: begin
                    z <= x;            // Pass through
                    if (x) state <= FLIP; // Transition on first '1'
                end
                FLIP: begin
                    z <= ~x;           // Invert all bits
                end
                default: begin          // Synthesis safety
                    state <= PASS;
                    z <= x;
                end
            endcase
        end
    end

endmodule