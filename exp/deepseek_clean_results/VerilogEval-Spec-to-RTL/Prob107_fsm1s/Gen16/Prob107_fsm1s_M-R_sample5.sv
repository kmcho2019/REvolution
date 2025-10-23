module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    wire next_state;
    reg state;  // 0=B, 1=A
    
    // Combinational next state logic
    assign next_state = (state & in) | (~state & ~in);
    
    // State register with synchronous reset
    always @(posedge clk) begin
        state <= reset ? 1'b0 : next_state;
    end
    
    // Moore output logic
    assign out = ~state;
    
endmodule