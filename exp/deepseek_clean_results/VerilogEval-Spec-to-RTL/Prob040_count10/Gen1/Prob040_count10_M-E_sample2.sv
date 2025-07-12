module TopModule (
    input clk,
    input reset,
    output [3:0] q
);

reg [9:0] onehot;

// One-hot state transitions
always @(posedge clk) begin
    if (reset) begin
        onehot <= 10'b0000000001;
    end
    else begin
        onehot <= {onehot[8:0], onehot[9]}; // Rotate left
    end
end

// Priority encoder to convert one-hot to binary
assign q = (onehot[0] ? 4'd0 :
           (onehot[1] ? 4'd1 :
           (onehot[2] ? 4'd2 :
           (onehot[3] ? 4'd3 :
           (onehot[4] ? 4'd4 :
           (onehot[5] ? 4'd5 :
           (onehot[6] ? 4'd6 :
           (onehot[7] ? 4'd7 :
           (onehot[8] ? 4'd8 :
           (onehot[9] ? 4'd9 : 4'd0))))))))));

endmodule