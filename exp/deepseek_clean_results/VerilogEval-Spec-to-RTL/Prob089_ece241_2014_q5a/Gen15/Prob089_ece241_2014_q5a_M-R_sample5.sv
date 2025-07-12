module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    localparam PASS = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    wire next_state;
    
    // Next state logic (combinational)
    assign next_state = (state == PASS) ? x : INVERT;
    
    // Output logic (combinational)
    assign z = (state == PASS) ? x : ~x;
    
    // State register (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= PASS;
        end else begin
            state <= next_state;
        end
    end

endmodule