module TopModule (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    wire next_state;
    
    assign next_state = (state & ~b) | (a & b);
    wire next_q = (a & b) | (state & b);
    
    always @(posedge clk) begin
        state <= next_state;
        q <= next_q;
    end

endmodule