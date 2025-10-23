module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    // T-flip-flop implementation
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else if ((state & k) | (~state & j)) begin
            state <= ~state;
        end
    end
    
    assign out = state;
endmodule