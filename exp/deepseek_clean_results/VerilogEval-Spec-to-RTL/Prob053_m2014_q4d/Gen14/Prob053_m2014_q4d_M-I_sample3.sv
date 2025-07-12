module TopModule (
    input clk,
    input in,
    output out
);

    reg state;
    wire next_state = in ^ state;
    
    assign out = state;
    
    always @(posedge clk) begin
        state <= next_state;
    end

endmodule