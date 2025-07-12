module TopModule (
    input clk,
    input L,
    input q_in,    // next value input when L=0 (combinational feedback)
    input r_in,    // parallel load input when L=1
    output reg Q
);

    wire d; // mux output

    assign d = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= d;
    end

endmodule