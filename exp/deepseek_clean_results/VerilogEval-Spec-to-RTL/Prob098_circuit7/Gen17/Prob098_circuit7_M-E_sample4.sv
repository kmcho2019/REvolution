module TopModule(input clk, input a, output reg q);
    // State definition
    localparam STATE_1 = 1'b1;
    localparam STATE_0 = 1'b0;
    
    always @(posedge clk) begin
        case(q)
            STATE_1: q <= (a) ? STATE_0 : STATE_1;
            STATE_0: q <= (a) ? STATE_0 : STATE_1;
        endcase
    end
endmodule