module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    reg [7:0] Q;
    
    // 8-bit shift register
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};
        end
    end
    
    // 8:1 multiplexer for output selection
    assign Z = Q[{A, B, C}];
endmodule