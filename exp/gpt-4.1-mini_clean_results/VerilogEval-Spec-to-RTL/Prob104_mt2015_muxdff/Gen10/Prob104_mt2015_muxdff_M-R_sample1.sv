module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    reg mux_out;

    // Combinational block for 2:1 mux logic
    always @(*) begin
        if (L)
            mux_out = r_in;
        else
            mux_out = q_in;
    end

    // Sequential block to register mux_out into Q
    always @(posedge clk) begin
        Q <= mux_out;
    end

endmodule