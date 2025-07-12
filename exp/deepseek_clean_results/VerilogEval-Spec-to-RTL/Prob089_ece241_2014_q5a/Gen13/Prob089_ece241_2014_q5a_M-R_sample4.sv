module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter PASS = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;

    // Combinational output based on current state and input
    assign z = (state == PASS) ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end
        else begin
            if (state == PASS && x)
                state <= INVERT;
            // State remains unchanged once in INVERT
        end
    end

endmodule