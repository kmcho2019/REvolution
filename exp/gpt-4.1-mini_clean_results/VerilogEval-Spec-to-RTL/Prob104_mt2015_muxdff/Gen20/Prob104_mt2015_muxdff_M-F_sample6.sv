module TopModule (
    input  clk,
    input  rst_n,  // Active-low asynchronous reset
    input  L,
    input  q_in,
    input  r_in,
    output reg Q
);

    wire mux_out;
    assign mux_out = L ? r_in : q_in;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            Q <= 1'b0;
        else
            Q <= mux_out;
    end

endmodule