module TopModule (
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    // Intermediate wire representing combined select condition
    wire sel_b = sel_b1 & sel_b2;

    // Intermediate data wires to demonstrate separation of data and control
    wire data_a = a;
    wire data_b = b;

    // Continuous assignment using conditional operator on intermediate signals
    assign out_assign = sel_b ? data_b : data_a;

    // Procedural block using if-else on the intermediate select signal
    always @(*) begin
        if (sel_b)
            out_always = data_b;
        else
            out_always = data_a;
    end

endmodule