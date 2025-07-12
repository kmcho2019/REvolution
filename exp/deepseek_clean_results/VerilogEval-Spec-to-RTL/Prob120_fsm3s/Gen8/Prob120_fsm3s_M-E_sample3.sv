module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    reg [3:0] state;
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;

    // Next state logic (parallel equations)
    wire [3:0] next_state;
    assign next_state[0] = (~state[0] & ~state[1] & ~state[2] & ~state[3]) |  // Reset case
                          (state[2] & ~in);                                   // C -> A when in=0
    assign next_state[1] = (state[0] & in) |                                  // A -> B when in=1
                          (state[1] & in) |                                  // B -> B when in=1
                          (state[3] & in);                                    // D -> B when in=1
    assign next_state[2] = (state[1] & ~in) |                                 // B -> C when in=0
                          (state[3] & ~in) |                                  // D -> C when in=0
                          (state[2] & in);                                    // C -> D when in=1
    assign next_state[3] = (state[2] & in);                                   // C -> D when in=1

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic
    assign out = state[3];  // Output 1 when in state D

endmodule