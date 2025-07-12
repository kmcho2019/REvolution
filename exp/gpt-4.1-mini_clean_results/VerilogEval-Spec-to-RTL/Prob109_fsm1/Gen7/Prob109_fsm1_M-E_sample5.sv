module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // One-hot encoding of states
    localparam [1:0] A = 2'b01;
    localparam [1:0] B = 2'b10;

    reg [1:0] state, next_state;

    // Next state logic: simple bitwise conditions
    always @(*) begin
        // Default next_state same as current state
        next_state = state;

        if (state == B) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else if (state == A) begin
            if (in == 1'b0)
                next_state = B;
            else
                next_state = A;
        end else begin
            // Safety fallback
            next_state = B;
        end
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= B;
        else
            state <= next_state;
    end

    // Output is 1 if in state B, 0 if in state A (Moore output)
    always @(*) begin
        out = (state == B);
    end

endmodule