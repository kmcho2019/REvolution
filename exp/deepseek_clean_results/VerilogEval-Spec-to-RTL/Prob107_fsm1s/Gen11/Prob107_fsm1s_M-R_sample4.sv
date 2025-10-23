module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    reg state;  // 0=B, 1=A
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == 0) ? (in ? 0 : 1) : (in ? 1 : 0);

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        state <= reset ? 0 : next_state;
    end

    // Output logic (Moore)
    assign out = ~state;  // out=1 when state B (0), out=0 when state A (1)

endmodule