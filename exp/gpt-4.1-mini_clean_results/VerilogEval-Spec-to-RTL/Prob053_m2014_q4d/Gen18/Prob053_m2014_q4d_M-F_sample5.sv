module TopModule (
    input clk,
    input in,
    output out
);

    reg state = 1'b0;   // Initialize state to 0 to avoid unknown start in simulation
    wire d_next;

    // Compute next state as XOR of current input and registered state
    assign d_next = in ^ state;

    // On positive clock edge, update state to d_next
    always @(posedge clk) begin
        state <= d_next;
    end

    // Drive output from registered state
    assign out = state;

endmodule