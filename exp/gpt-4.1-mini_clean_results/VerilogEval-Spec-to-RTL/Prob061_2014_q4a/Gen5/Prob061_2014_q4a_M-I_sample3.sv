module TopModule (
    input  logic clk,
    input  logic w,
    input  logic R,
    input  logic E,
    input  logic L,
    output logic Q
);

    logic next_Q;

    // Combinational logic for next state, incorporates enable/load control inside mux
    always_comb begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential logic without explicit clock enable
    always_ff @(posedge clk) begin
        Q <= next_Q;
    end

endmodule