module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // On the rising edge of clk, load Q with r_in if L=1, else with q_in
    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule