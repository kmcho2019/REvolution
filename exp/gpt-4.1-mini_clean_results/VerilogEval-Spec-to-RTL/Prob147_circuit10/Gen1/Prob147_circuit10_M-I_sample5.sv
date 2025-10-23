module TopModule (
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);
    reg state_reg;

    // Combinational output logic matching waveform
    assign q = a ^ (b & state_reg);
    assign state = state_reg;

    // Sequential update on rising clock edge
    always @(posedge clk) begin
        state_reg <= q;
    end

endmodule