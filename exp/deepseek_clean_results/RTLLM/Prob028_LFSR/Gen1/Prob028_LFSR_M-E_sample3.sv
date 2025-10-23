module LFSR (
    input clk,
    input rst,
    output reg [3:0] out
);

reg mode;  // 0: left shift, 1: right shift
reg feedback_sel;  // 0: use bits 3-2, 1: use bits 1-0

always @(posedge clk) begin
    if (rst) begin
        out <= 4'b0001;  // Non-zero seed
        mode <= 0;
        feedback_sel <= 0;
    end
    else begin
        // Toggle mode and feedback selection
        mode <= ~mode;
        feedback_sel <= ~feedback_sel;
        
        // Calculate feedback based on selection
        reg feedback;
        if (feedback_sel)
            feedback = ~(out[1] ^ out[0]);  // XOR bits 1-0
        else
            feedback = ~(out[3] ^ out[2]);  // XOR bits 3-2
            
        // Shift based on mode
        if (mode)
            out <= {feedback, out[3:1]};  // Right shift
        else
            out <= {out[2:0], feedback};  // Left shift
    end
end

endmodule