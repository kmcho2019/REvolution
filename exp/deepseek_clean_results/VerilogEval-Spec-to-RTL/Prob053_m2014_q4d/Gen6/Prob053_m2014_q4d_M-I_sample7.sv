module TopModule (
    input clk,
    input in,
    output out
);

    reg q = 1'b0;  // Initialize to 0 for consistent simulation
    
    assign out = q;

    always @(posedge clk) begin
        q <= in ^ q;
    end

endmodule