module TopModule(input clk, input a, output reg q);
    // State definition
    localparam STATE_0 = 1'b0;
    localparam STATE_1 = 1'b1;
    
    reg state;
    
    always @(posedge clk) begin
        case (state)
            STATE_0: state <= a ? STATE_0 : STATE_1;
            STATE_1: state <= a ? STATE_0 : STATE_1;
        endcase
    end
    
    always @(*) begin
        q = state;
    end
endmodule