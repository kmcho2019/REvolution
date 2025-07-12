module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire d_next;

    // Combinational logic for the next state
    assign d_next = in ^ state;

    // Sequential logic: update state on rising edge of clk
    always @(posedge clk) begin
        state <= d_next;
    end

    // Output is the current state
    assign out = state;

endmodule