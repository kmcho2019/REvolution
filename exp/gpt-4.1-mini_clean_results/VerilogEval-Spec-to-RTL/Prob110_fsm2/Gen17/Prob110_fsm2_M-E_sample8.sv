module TopModule(
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

    // One-hot state encoding
    // state_off = 1'b1 when in OFF state
    // state_on  = 1'b1 when in ON state

    reg state_off, state_on;
    reg next_off, next_on;

    // Next state combinational logic
    always @(*) begin
        // Default to current state to avoid latches
        next_off = state_off;
        next_on  = state_on;

        case ({state_off, state_on})
            2'b10: begin // OFF state
                if (j)
                    {next_off, next_on} = 2'b01; // Move to ON
                else
                    {next_off, next_on} = 2'b10; // Stay OFF
            end
            2'b01: begin // ON state
                if (k)
                    {next_off, next_on} = 2'b10; // Move to OFF
                else
                    {next_off, next_on} = 2'b01; // Stay ON
            end
            default: begin
                // Safety: reset to OFF if in invalid state
                {next_off, next_on} = 2'b10;
            end
        endcase
    end

    // State registers with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_off <= 1'b1;  // OFF state active on reset
            state_on  <= 1'b0;
        end else begin
            state_off <= next_off;
            state_on  <= next_on;
        end
    end

    // Output logic: out=1 when ON state is active (Moore)
    assign out = state_on;

endmodule