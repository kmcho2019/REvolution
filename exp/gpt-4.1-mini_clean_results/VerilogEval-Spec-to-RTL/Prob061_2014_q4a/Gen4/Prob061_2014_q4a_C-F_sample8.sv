module TopModule (
    input  logic clk,
    input  logic w,
    input  logic R,
    input  logic E,
    input  logic L,
    output logic Q
);

    logic next_Q;
    logic ce; // clock enable signal

    // Compute clock enable: update Q only when load or enable is asserted
    assign ce = L | E;

    // Combinational logic for next state
    always_comb begin
        if (L)
            next_Q = R;
        else if (E)
            next_Q = w;
        else
            next_Q = Q;
    end

    // Sequential logic with clock enable to reduce toggling power
    always_ff @(posedge clk) begin
        if (ce)
            Q <= next_Q;
        else
            Q <= Q;
    end

endmodule