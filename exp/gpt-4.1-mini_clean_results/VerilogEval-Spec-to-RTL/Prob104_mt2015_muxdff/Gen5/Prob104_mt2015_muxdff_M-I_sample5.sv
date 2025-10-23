module TopModule (
    input clk,
    input L,
    input q_next_in,  // combinational next value when L=0
    input r_in,       // parallel load input when L=1
    output reg Q
);

    always @(posedge clk) begin
        if (L)
            Q <= r_in;
        else
            Q <= q_next_in;
    end

endmodule