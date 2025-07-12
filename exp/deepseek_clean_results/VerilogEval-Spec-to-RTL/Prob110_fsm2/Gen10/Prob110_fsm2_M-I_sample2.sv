module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    
    // Combined sequential and combinational logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            state <= (state & ~k) | (~state & j);
        end
    end
    
    // Output assignment
    assign out = state;
endmodule