module mux2to1 (
    input sel,
    input d0,
    input d1,
    output y
);
    assign y = sel ? d1 : d0;
endmodule

module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    // Instantiate 2:1 mux with inputs q_in and r_in, select L
    mux2to1 mux_inst (
        .sel(L),
        .d0(q_in),
        .d1(r_in),
        .y(mux_out)
    );

    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule