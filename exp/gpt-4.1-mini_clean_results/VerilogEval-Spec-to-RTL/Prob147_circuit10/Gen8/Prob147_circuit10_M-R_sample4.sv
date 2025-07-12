module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    reg next_state;

    // Combinational logic to determine next_state and q
    always @* begin
        // Next state logic
        if (state == 1'b1) begin
            if (a == 1'b1 && b == 1'b1)
                next_state = 1'b0; // reset state
            else
                next_state = 1'b1; // hold state
        end else begin
            // state == 0
            if (b == 1'b1 && a == 1'b0)
                next_state = 1'b1; // set state
            else
                next_state = 1'b0; // hold state
        end

        // Output q logic
        if (state == 1'b1) begin
            if (a == 1'b0 || b == 1'b0)
                q = 1'b1;
            else
                q = 1'b0;
        end else begin
            // state == 0
            if (a == 1'b1 && b == 1'b1)
                q = 1'b1;
            else
                q = 1'b0;
        end
    end

    // Sequential update of state at posedge clk
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule