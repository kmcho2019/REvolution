module TopModule (
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q <= 16'd0;
        ena <= 3'b000;
    end else begin
        // Initialize enable signals to 0
        ena <= 3'b000;

        // Increment the counter
        if (q[3:0] == 4'd9) begin
            q[3:0] <= 4'd0;
            ena[0] <= 1'b1;  // Enable tens digit to increment
            if (q[7:4] == 4'd9) begin
                q[7:4] <= 4'd0;
                ena[1] <= 1'b1;  // Enable hundreds digit to increment
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena[2] <= 1'b1;  // Enable thousands digit to increment
                    q[15:12] <= q[15:12] + 1'd1;
                end else begin
                    q[11:8] <= q[11:8] + 1'd1;
                end
            end else begin
                q[7:4] <= q[7:4] + 1'd1;
            end
        end else begin
            q[3:0] <= q[3:0] + 1'd1;
        end
    end
end

endmodule