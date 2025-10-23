module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Johnson counter state transitions with decade extension
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end
    else begin
        case (q)
            // Normal Johnson counter sequence
            4'b0000: q <= 4'b1000;
            4'b1000: q <= 4'b1100;
            4'b1100: q <= 4'b1110;
            4'b1110: q <= 4'b1111;
            4'b1111: q <= 4'b0111;
            4'b0111: q <= 4'b0011;
            4'b0011: q <= 4'b0001;
            
            // Extended states for decade counting
            4'b0001: q <= 4'b1001;  // Extra state 1
            4'b1001: q <= 4'b1101;  // Extra state 2
            4'b1101: q <= 4'b0000;  // Back to start
            
            default: q <= 4'b0000;
        endcase
    end
end

endmodule