module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    output reg Q
);

    wire d;  // Mux output

    assign d = L ? r_in : q_in;  // 2:1 mux selects input based on L

    initial begin
        Q = 1'b0;  // Initialize Q to zero to avoid unknown startup values
    end

    always @(posedge clk) begin
        Q <= d;  // D flip-flop capturing mux output
    end

endmodule