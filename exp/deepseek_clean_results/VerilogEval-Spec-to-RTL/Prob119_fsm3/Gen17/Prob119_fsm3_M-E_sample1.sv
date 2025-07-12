module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg [3:0] state; // One-hot encoding: A=0001, B=0010, C=0100, D=1000

    // State bit 0 (A)
    always @(posedge clk or posedge areset) begin
        if (areset) state[0] <= 1'b1;
        else state[0] <= (state[0] & ~in) | (state[2] & ~in);
    end

    // State bit 1 (B)
    always @(posedge clk or posedge areset) begin
        if (areset) state[1] <= 1'b0;
        else state[1] <= (state[0] & in) | (state[1] & in) | (state[3] & ~in);
    end

    // State bit 2 (C)
    always @(posedge clk or posedge areset) begin
        if (areset) state[2] <= 1'b0;
        else state[2] <= (state[1] & ~in) | (state[3] & ~in) | (state[2] & ~in);
    end

    // State bit 3 (D)
    always @(posedge clk or posedge areset) begin
        if (areset) state[3] <= 1'b0;
        else state[3] <= (state[2] & in);
    end

    assign out = state[3]; // Output is directly state D

endmodule