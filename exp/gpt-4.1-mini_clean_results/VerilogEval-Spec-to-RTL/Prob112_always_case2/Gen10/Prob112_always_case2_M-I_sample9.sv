module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    wire not_in0 = ~in[0];
    wire not_in1 = ~in[1];
    wire not_in2 = ~in[2];

    always @(*) begin
        if (in[0])
            pos = 2'd0;
        else if (in[1])
            pos = 2'd1;
        else if (in[2])
            pos = 2'd2;
        else if (in[3])
            pos = 2'd3;
        else
            pos = 2'd0;
    end
endmodule