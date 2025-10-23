module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    // Initialize Q to 0
    initial begin
        Q = 1'b0;
    end

    // Mux logic
    wire next_state = L ? r_in : q_in;

    // Synchronous update
    always @(posedge clk) begin
        Q <= next_state;
    end

endmodule