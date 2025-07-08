module TopModule (
    input clk,
    input L,
    input q_in,  // Feedback input for when L=0
    input r_in,  // Load input for when L=1
    output Q     // Output of the flip-flop
);

    reg q_reg;
    
    always @(posedge clk) begin
        if (L) begin
            q_reg <= r_in;
        end else begin
            q_reg <= q_in;
        end
    end
    
    assign Q = q_reg;

endmodule