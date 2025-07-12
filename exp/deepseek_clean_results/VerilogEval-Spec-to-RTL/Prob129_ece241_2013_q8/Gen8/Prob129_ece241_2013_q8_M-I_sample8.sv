module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] hist;
    
    always @(posedge clk or negedge aresetn)
        hist <= !aresetn ? 2'b0 : {hist[0], x};
    
    assign z = (hist == 2'b10) & x;

endmodule