module TopModule (
    input clk,
    input L,
    input [1:0] pos,  // Position in the 3-bit register (0,1,2)
    input q_in,       // Feedback input
    input r_in,       // Load input
    output reg Q      // Output
);

    // Internal feedback logic signals
    wire feedback;

    // Position-specific feedback logic
    assign feedback = (pos == 2'b00) ? q_in :         // q[0] gets q[1]^q[2] from full_module wiring
                     (pos == 2'b01) ? Q :             // q[1] gets q[0]
                     (pos == 2'b10) ? Q : 1'b0;       // q[2] gets q[2] (hold)

    always @(posedge clk) begin
        if (L) begin
            Q <= r_in;  // Load mode
        end else begin
            Q <= feedback;  // Position-specific operation mode
        end
    end

endmodule