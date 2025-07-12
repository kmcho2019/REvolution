module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // Named states with efficient binary encoding
    localparam STATE_B = 1'b0;
    localparam STATE_A = 1'b1;
    
    reg state;
    
    // Optimized state transition with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_B;
        end else begin
            case (state)
                STATE_B: state <= in ? STATE_B : STATE_A;
                STATE_A: state <= in ? STATE_A : STATE_B;
            endcase
        end
    end
    
    // Direct output assignment
    assign out = (state == STATE_B);
    
endmodule