module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state bits
    reg OFF_state, ON_state;
    reg OFF_next, ON_next;

    // Next state logic (combinational)
    always @(*) begin
        OFF_next = 1'b0;
        ON_next  = 1'b0;

        if (OFF_state) begin
            if (j)
                ON_next = 1'b1;
            else
                OFF_next = 1'b1;
        end else if (ON_state) begin
            if (k)
                OFF_next = 1'b1;
            else
                ON_next = 1'b1;
        end else begin
            // Invalid state, reset to OFF
            OFF_next = 1'b1;
        end
    end

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            OFF_state <= 1'b1;
            ON_state  <= 1'b0;
        end else begin
            OFF_state <= OFF_next;
            ON_state  <= ON_next;
        end
    end

    // Output depends only on ON_state (Moore output)
    assign out = ON_state;

endmodule