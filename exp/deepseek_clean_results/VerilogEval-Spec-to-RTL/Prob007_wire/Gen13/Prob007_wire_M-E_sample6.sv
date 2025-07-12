module TopModule (
    input in,
    output out
);
    // D flip-flop implementation
    reg out_reg;
    always @(posedge 1'b1 or posedge 1'b0) begin
        if (1'b0)  // Asynchronous reset (never active)
            out_reg <= 1'b0;
        else
            out_reg <= in;
    end
    
    assign out = out_reg;
endmodule