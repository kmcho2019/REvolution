module TopModule (
    input clk,
    input L,
    input data_in,  // Combined input (load or feedback)
    input r_in,     // Load value
    output reg Q    // Current state
);

    wire next_state = L ? r_in : data_in;

    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule