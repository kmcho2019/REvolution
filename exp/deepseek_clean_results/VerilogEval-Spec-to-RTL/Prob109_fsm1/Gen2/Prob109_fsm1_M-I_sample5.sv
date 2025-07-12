module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // Define states with more descriptive names
    reg state;
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;

    // State transition and output registration
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;
            out <= 1'b1;  // Registered output matches reset state
        end else begin
            // Simplified state transition logic
            state <= (state == STATE_A) ? (in ? STATE_A : STATE_B)
                                        : (in ? STATE_B : STATE_A);
            // Registered output
            out <= state;
        end
    end

endmodule