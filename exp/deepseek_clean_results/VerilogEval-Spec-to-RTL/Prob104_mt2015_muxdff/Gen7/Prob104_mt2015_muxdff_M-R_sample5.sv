module TopModule (
    input clk,
    input L,
    input q_in,     // Feedback value (computed externally)
    input r_in,     // Load value
    output reg Q
);

    wire next_state = L ? r_in : q_in;

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule