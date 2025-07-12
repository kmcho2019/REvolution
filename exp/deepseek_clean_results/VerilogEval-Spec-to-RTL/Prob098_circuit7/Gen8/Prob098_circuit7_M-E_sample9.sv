module TopModule(input clk, input a, output q);
    reg state;
    localparam HIGH = 1'b1;
    localparam LOW = 1'b0;
    
    assign q = state;
    
    always @(posedge clk) begin
        case (state)
            HIGH: state <= (a) ? LOW : HIGH;
            LOW: state <= (a) ? LOW : HIGH;
        endcase
    end
endmodule