module TopModule (
    input  logic clk,
    input  logic w,
    input  logic R,
    input  logic E,
    input  logic L,
    output logic Q
);

    logic next_Q;

    always_comb begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    always_ff @(posedge clk) begin
        Q <= next_Q;
    end

endmodule