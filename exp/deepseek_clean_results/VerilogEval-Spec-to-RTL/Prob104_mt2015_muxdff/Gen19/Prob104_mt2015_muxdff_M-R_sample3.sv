module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input
    input r_in,    // Parallel load input
    output Q
);

    wire d_input = L ? r_in : q_in;
    reg q_reg;

    // Flip-flop implementation using continuous assignment
    assign Q = q_reg;
    
    always @(posedge clk) begin
        q_reg <= d_input;
    end

endmodule