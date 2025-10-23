module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;  // 0=A, 1=B

    // Next state logic - move to B if x=1 in A, otherwise stay
    wire next_state = state | (x & ~state);

    // Output logic - same as before but using single state bit
    assign z = state ? ~x : x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;  // Reset to state A
        end
        else begin
            state <= next_state;
        end
    end

endmodule