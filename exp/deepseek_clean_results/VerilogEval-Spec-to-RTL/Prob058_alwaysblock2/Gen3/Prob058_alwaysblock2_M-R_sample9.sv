module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    ///////////////////////////////////
    // Combinational Implementations //
    ///////////////////////////////////
    
    // Continuous assignment style
    assign out_assign = a ^ b;
    
    // Always block style
    always @(*) begin
        out_always_comb = a ^ b;
    end

    //////////////////////////////////
    // Sequential Implementation    //
    //////////////////////////////////
    
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule