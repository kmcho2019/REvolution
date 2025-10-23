module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State definitions
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == STATE_B) ? ~in : in;

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;  // Synchronous reset to state B
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore style)
    assign out = ~state;  // B=1, A=0

endmodule