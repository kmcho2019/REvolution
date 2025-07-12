module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    reg [3:0] state;
    wire [3:0] next_state;

    // State transition equations
    assign next_state[0] = (~state[0] & ~state[1] & ~state[2] & ~state[3]) |  // Reset to A
                          (state[0] & ~in) |                                  // A stays A when in=0
                          (state[2] & ~in);                                   // C -> A when in=0

    assign next_state[1] = (state[0] & in) |                                  // A -> B when in=1
                          (state[1] & in) |                                  // B stays B when in=1
                          (state[3] & in);                                   // D -> B when in=1

    assign next_state[2] = (state[1] & ~in) |                                 // B -> C when in=0
                          (state[3] & ~in);                                  // D -> C when in=0

    assign next_state[3] = (state[2] & in);                                   // C -> D when in=1

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 4'b0001;  // Reset to state A
        end else begin
            state <= next_state;
        end
    end

    // Registered output (D state)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= state[3];
        end
    end

endmodule