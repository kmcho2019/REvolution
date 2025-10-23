module TopModule(
    input  clk,
    input  reset,
    output reg [2:0] ena, // 3 bits for enable signals of three upper digits
    output reg [15:0] q  // 16 bits for the 4-digit BCD counter
);

// Initialize enable signals
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ena <= 3'b000;
        q <= 16'd0;
    end else begin
        // Default: don't increment any digit
        ena <= 3'b000;

        // Increment ones digit
        if (q[3:0] == 4'd9) begin
            q[3:0] <= 4'd0; // Wrap around to 0
            ena[0] <= 1'b1; // Increment tens digit
            if (q[7:4] == 4'd9) begin
                q[7:4] <= 4'd0; // Wrap around to 0
                ena[1] <= 1'b1; // Increment hundreds digit
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0; // Wrap around to 0
                    ena[2] <= 1'b1; // Increment thousands digit
                    if (q[15:12] == 4'd9) begin
                        q[15:12] <= 4'd0; // Wrap around to 0
                    end else begin
                        q[15:12] <= q[15:12] + 1; // Increment thousands digit
                    end
                end else begin
                    q[11:8] <= q[11:8] + 1; // Increment hundreds digit
                end
            end else begin
                q[7:4] <= q[7:4] + 1; // Increment tens digit
            end
        end else begin
            q[3:0] <= q[3:0] + 1; // Increment ones digit
        end
    end
end

endmodule