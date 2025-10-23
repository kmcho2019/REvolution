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

    always @(posedge clk) 
        if (enable) 
            Q <= {S, Q[7:1]};

    assign Z = Q[{A,B,C]};

endmodule