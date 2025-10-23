module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    logic state; // Current state (A=0, B=1)

    // Sequential logic with asynchronous reset
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Asynchronously reset to state B
        end else begin
            // Simplified next state logic based on the state machine diagram
            state <= (state == 1'b0 && in == 1'b1)? 1'b0 : 
                     (state == 1'b1 && in == 1'b0)? 1'b0 : state;
        end
    end

    // Directly assign output based on the state
    assign out = state;

endmodule