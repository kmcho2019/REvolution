module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire j,
    input  wire k,
    output wire out
);

    reg state; // 0 = OFF, 1 = ON

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0;  // OFF state
        else begin
            if (state == 1'b0)        // OFF
                state <= j ? 1'b1 : 1'b0;  // transition to ON if j=1
            else                      // ON
                state <= k ? 1'b0 : 1'b1;  // transition to OFF if k=1
        end
    end

    // Output is directly the current state (Moore machine)
    assign out = state;

endmodule