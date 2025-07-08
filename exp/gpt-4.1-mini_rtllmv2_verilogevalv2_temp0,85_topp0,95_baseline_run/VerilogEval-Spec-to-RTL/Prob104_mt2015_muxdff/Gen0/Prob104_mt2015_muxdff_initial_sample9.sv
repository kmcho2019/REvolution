module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);
    wire mux_out;

    // 2:1 Multiplexer: if L=1 select r_in else q_in
    assign mux_out = L ? r_in : q_in;

    // D flip-flop: capture mux_out on posedge clk
    always @(posedge clk) begin
        Q <= mux_out;
    end
endmodule