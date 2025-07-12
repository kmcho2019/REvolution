module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] hist;  // 2-bit history register

    always @(posedge clk or negedge aresetn)
        if (!aresetn) hist <= 2'b0;
        else hist <= {hist[0], x};

    assign z = (hist == 2'b10) & x;  // Detect "101" pattern

endmodule