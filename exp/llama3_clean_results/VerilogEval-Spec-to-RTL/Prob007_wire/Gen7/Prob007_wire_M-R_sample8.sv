module TopModule(
    input  in,
    output reg out
);
    
    // Always block to mimic wire behavior
    always @(*) begin
        out = in;
    end

endmodule