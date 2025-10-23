module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    // One-hot state encoding
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // Next state logic (combinational)
    always @(*) begin
        // Default next state to hold current
        next_state = 4'b0000;

        if (state == A) begin
            if (in)
                next_state = B;
            else
                next_state = A;
        end else if (state == B) begin
            if (in)
                next_state = B;
            else
                next_state = C;
        end else if (state == C) begin
            if (in)
                next_state = D;
            else
                next_state = A;
        end else if (state == D) begin
            if (in)
                next_state = B;
            else
                next_state = C;
        end else begin
            next_state = A;  // Safe fallback
        end
    end

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;  // Reset to state A
        else
            state <= next_state;
    end

    // Output logic based on one-hot current state (Moore output)
    always @(*) begin
        out = (state == D);
    end

endmodule