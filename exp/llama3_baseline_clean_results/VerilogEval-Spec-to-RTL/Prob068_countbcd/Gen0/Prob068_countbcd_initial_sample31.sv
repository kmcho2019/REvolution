module TopModule(
    input       clk,
    input       reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 16'd0;
        ena <= 3'd0;
    end else begin
        // Default condition: Don't increment
        ena <= 3'd0;
        
        // Increment ones place
        if (q[3:0] == 4'd9) begin
            q[3:0] <= 4'd0; // Reset ones place
            ena[0] <= 1'b1; // Enable tens place
        end else begin
            q[3:0] <= q[3:0] + 1'b1;
        end
        
        // Increment tens place if enabled
        if (ena[0] && q[7:4] == 4'd9) begin
            q[7:4] <= 4'd0; // Reset tens place
            ena[1] <= 1'b1; // Enable hundreds place
        end else if (ena[0]) begin
            q[7:4] <= q[7:4] + 1'b1;
        end
        
        // Increment hundreds place if enabled
        if (ena[1] && q[11:8] == 4'd9) begin
            q[11:8] <= 4'd0; // Reset hundreds place
            ena[2] <= 1'b1; // Enable thousands place
        end else if (ena[1]) begin
            q[11:8] <= q[11:8] + 1'b1;
        end
        
        // Increment thousands place if enabled
        if (ena[2]) begin
            if (q[15:12] == 4'd9) begin
                q[15:12] <= 4'd0; // Wrap around
            end else begin
                q[15:12] <= q[15:12] + 1'b1;
            end
        end
    end
end

endmodule