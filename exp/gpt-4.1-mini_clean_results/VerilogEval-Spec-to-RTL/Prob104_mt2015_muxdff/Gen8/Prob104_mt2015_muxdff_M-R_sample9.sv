module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire next_Q;
    assign next_Q = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= next_Q;
    end

endmodule