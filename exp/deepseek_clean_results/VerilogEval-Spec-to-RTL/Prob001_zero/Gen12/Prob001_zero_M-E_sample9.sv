module TopModule(output zero);
    reg out = 0;
    assign zero = out;
    
    always @(posedge 1'b0 or posedge 1'b1) begin
        if (1'b1) out <= 1'b0;
        else out <= 1'b0;
    end
endmodule