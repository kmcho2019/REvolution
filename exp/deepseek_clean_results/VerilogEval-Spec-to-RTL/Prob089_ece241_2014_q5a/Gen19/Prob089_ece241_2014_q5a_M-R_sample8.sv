module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter STATE_PASS = 1'b0;
    parameter STATE_INVERT = 1'b1;
    
    reg state;
    
    // Output combinational logic
    assign z = (state == STATE_PASS) ? x : ~x;
    
    // State transition sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= STATE_PASS;
        end else begin
            state <= (state == STATE_PASS && x) ? STATE_INVERT : state;
        end
    end

endmodule