module TopModule (
    input clk,
    input L,
    input q_in,  // Carries the specific feedback value for this bit
    input r_in,  // Load value
    output reg Q
);

    always @(posedge clk) begin
        Q <= L ? r_in : q_in;
    end

endmodule