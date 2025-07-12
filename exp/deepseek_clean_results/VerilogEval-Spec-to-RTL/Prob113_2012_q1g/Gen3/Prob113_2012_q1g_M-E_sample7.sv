module TopModule(
    input [3:0] x,
    output f
);
    wire [1:0] sel = x[3:2];
    wire [1:0] low = x[1:0];
    reg out;
    
    always @(*) begin
        case(sel)
            2'b00: out = ~low[1];                // f = x[1]' for x[3:2]=00
            2'b01: out = 1'b0;                   // Always 0 for x[3:2]=01
            2'b11: out = low[0] | ~low[1];       // f = x[0] OR NOT x[1] for x[3:2]=11
            2'b10: out = ~low[0] | ~low[1];      // f = NOT x[0] OR NOT x[1] for x[3:2]=10
            default: out = 1'b0;
        endcase
    end
    
    assign f = out;
endmodule