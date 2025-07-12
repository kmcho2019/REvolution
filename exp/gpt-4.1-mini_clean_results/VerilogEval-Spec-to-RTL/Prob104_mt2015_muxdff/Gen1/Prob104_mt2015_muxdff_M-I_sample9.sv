module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

wire mux_out = L ? r_in : q_in;
wire update_en = (mux_out != Q);

always @(posedge clk) begin
    if (update_en)
        Q <= mux_out;
end

endmodule