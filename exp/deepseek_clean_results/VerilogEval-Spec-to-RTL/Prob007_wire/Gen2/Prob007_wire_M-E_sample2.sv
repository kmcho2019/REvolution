module TopModule (
    input in,
    output out
);
    reg out_reg;
    
    always @(posedge in or negedge 1'b0) begin
        if (!1'b0) begin  // Reset never occurs
            out_reg <= 1'b0;
        end else begin
            out_reg <= in;
        end
    end
    
    assign out = out_reg;
endmodule