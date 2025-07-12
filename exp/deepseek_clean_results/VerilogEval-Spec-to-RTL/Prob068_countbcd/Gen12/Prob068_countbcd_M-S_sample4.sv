module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Ones digit (always increments)
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                ena[0] <= 1'b1;  // Enable tens digit
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
                ena[0] <= 1'b0;
            end

            // Tens digit (increments only when enabled)
            if (ena[0]) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    ena[1] <= 1'b1;  // Enable hundreds digit
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                    ena[1] <= 1'b0;
                end
            end else begin
                ena[1] <= 1'b0;
            end

            // Hundreds digit (increments only when enabled)
            if (ena[1]) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    ena[2] <= 1'b1;  // Enable thousands digit
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Thousands digit (increments only when enabled)
            if (ena[2]) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end

endmodule