module TopModule (
    input clk,
    input L,
    input q_in,     // Feedback input from adjacent flip-flops
    input r_in,     // Parallel load input
    output Q        // Current state output
);

    reg q_reg;
    wire feedback_in;
    
    // XOR gate for the specific feedback pattern (q[1] ^ q[2])
    assign feedback_in = q_in ^ Q;
    
    always @(posedge clk) begin
        if (L) begin
            q_reg <= r_in;          // Parallel load mode
        end else begin
            q_reg <= feedback_in;    // Feedback operation mode
        end
    end
    
    assign Q = q_reg;

endmodule