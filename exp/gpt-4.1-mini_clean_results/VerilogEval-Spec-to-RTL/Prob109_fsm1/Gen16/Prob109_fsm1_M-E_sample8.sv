module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // One-hot encoding states
    localparam B = 2'b10;
    localparam A = 2'b01;

    reg [1:0] state, next_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;  // Reset to state B
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b0)
                    next_state = A;  // B->A on 0
                else
                    next_state = B;  // B->B on 1
            end
            A: begin
                if (in == 1'b0)
                    next_state = B;  // A->B on 0
                else
                    next_state = A;  // A->A on 1
            end
            default: next_state = B; // Safety default to B
        endcase
    end

    // Moore output: out=1 when in state B (2'b10), else 0
    assign out = state[1]; // MSB set only for B state

endmodule