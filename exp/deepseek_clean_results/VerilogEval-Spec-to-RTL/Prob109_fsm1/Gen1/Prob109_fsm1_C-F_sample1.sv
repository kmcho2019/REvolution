module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // Define states with clear names
    localparam STATE_A = 1'b0;
    localparam STATE_B = 1'b1;
    
    reg state;

    // State transition with efficient encoding
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_B;  // Async reset to B
        end else begin
            state <= (state == STATE_A) ? (in ? STATE_A : STATE_B)
                                       : (in ? STATE_B : STATE_A);
        end
    end

    // Direct state-to-output mapping (most efficient)
    assign out = state;

endmodule