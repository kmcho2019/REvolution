module TopModule(
    input  wire a,
    input  wire b,
    input  wire sel_b1,
    input  wire sel_b2,
    output wire out_assign,
    output reg  out_always
);

    wire sel = sel_b1 & sel_b2;
    wire [1:0] data_vec = {a, b};

    // Continuous assignment: select bit using sel as index
    assign out_assign = data_vec[sel];

    // Procedural block: select bit from data_vec using sel as index
    always @(*) begin
        if (sel)
            out_always = data_vec[1];  // b
        else
            out_always = data_vec[0];  // a
    end

endmodule