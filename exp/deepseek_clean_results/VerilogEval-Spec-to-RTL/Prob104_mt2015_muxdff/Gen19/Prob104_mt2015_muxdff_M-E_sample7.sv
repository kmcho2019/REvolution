module TopModule (
    input clk,
    input L,
    input q_in,
    input r_in,
    input [1:0] fb_mode,  // Feedback mode selector
    output reg Q
);

    wire feedback_val;
    
    // Feedback computation
    assign feedback_val = (fb_mode == 2'b01) ? Q :        // Hold
                         (fb_mode == 2'b10) ? q_in :      // Previous bit
                         (fb_mode == 2'b11) ? (Q ^ q_in) : // XOR
                         1'b0;                            // Default
    
    always @(posedge clk) begin
        Q <= L ? r_in : feedback_val;
    end

endmodule