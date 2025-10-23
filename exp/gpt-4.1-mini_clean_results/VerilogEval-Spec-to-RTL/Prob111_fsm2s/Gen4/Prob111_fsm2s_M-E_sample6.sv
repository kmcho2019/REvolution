module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);
    // One-hot state registers
    reg off_state, on_state;

    // Next state combinational signals
    wire next_off, next_on;

    // Next state logic for OFF state
    assign next_off = (off_state && ~j) || (on_state && k);
    // Next state logic for ON state
    assign next_on = (off_state && j) || (on_state && ~k);

    // State registers update with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            off_state <= 1'b1;  // OFF state
            on_state <= 1'b0;
        end else begin
            off_state <= next_off;
            on_state <= next_on;
        end
    end

    // Output directly driven by on_state (Moore machine)
    assign out = on_state;

endmodule