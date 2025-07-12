module TopModule (
    input clk,
    input reset,
    input slowena,
    output [3:0] q
);

reg [9:0] state;

// One-hot to binary encoder
assign q = (state == 10'b0000000001) ? 4'd0 :
           (state == 10'b0000000010) ? 4'd1 :
           (state == 10'b0000000100) ? 4'd2 :
           (state == 10'b0000001000) ? 4'd3 :
           (state == 10'b0000010000) ? 4'd4 :
           (state == 10'b0000100000) ? 4'd5 :
           (state == 10'b0001000000) ? 4'd6 :
           (state == 10'b0010000000) ? 4'd7 :
           (state == 10'b0100000000) ? 4'd8 :
                                       4'd9;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001;  // Reset to state 0
    end
    else if (slowena) begin
        state <= {state[8:0], state[9]};  // Rotate left
    end
end

endmodule