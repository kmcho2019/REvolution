module TopModule (
    input clk,
    input L,
    input q_in,  // Feedback input
    input r_in,  // Load input
    output reg Q
);

    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule