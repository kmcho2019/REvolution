module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions with explicit encoding
    localparam PASS = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    
    // Output is pure combinational based on current state and input
    assign z = (state == PASS) ? x : ~x;
    
    // State transitions (sequential logic only)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            state <= (state == PASS) ? (x ? INVERT : PASS) : INVERT;
        end
    end

endmodule