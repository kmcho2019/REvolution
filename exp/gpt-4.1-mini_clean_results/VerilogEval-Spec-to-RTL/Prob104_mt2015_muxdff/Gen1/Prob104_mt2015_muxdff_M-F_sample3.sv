module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire mux_out;

    // 2:1 MUX: if L=1 select r_in, else q_in
    assign mux_out = L ? r_in : q_in;

    // D flip-flop: on rising clk, store mux_out
    always @(posedge clk) begin
        Q <= mux_out;
    end

    // Initialize Q to 0 to avoid simulation mismatches due to undefined initial value
    initial begin
        Q = 1'b0;
    end

endmodule