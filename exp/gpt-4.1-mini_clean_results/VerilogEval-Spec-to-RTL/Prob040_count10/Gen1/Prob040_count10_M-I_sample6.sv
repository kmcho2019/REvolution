module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    // One-hot counter register: 10 bits for counts 0 to 9
    reg [9:0] onehot;

    // Priority encoder to convert one-hot to binary count
    integer i;

    always @(posedge clk) begin
        if (reset)
            onehot <= 10'b0000000001;  // count 0
        else begin
            // Rotate the '1' to the next bit, wrap after count 9
            if (onehot[9])
                onehot <= 10'b0000000001;
            else
                onehot <= onehot << 1;
        end
    end

    always @(*) begin
        // Default output 0
        q = 4'd0;
        // Find the index of the set bit in onehot and assign to q
        for (i = 0; i < 10; i = i + 1) begin
            if (onehot[i]) q = i[3:0];
        end
    end

endmodule