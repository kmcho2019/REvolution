module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q = 1'b0  // Initialize to 0 for deterministic behavior
);

    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule