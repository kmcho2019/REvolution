module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    wire [1:0] priority;
    assign priority[0] = (a < b) & (a < c) & (a < d);
    assign priority[1] = (b < a) & (b < c) & (b < d);

    wire [1:0] priority_c_d;
    assign priority_c_d[0] = (c < d);
    assign priority_c_d[1] = (d < c);

    wire [1:0] final_priority;
    assign final_priority[0] = priority[0] | ((~priority[0]) & (~priority[1]) & priority_c_d[0]);
    assign final_priority[1] = priority[1] | ((~priority[0]) & (~priority[1]) & priority_c_d[1]);

    assign min = (final_priority[0]) ? a :
                 (final_priority[1]) ? b :
                 (priority_c_d[0]) ? c : d;

endmodule