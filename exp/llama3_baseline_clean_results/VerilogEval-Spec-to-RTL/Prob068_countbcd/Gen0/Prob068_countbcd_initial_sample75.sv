module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q0, q1, q2, q3;

// Initialize the counter values to 0
initial begin
    q0 = 4'd0;
    q1 = 4'd0;
    q2 = 4'd0;
    q3 = 4'd0;
end

// Synchronous active-high reset
always @(posedge clk) begin
    if (reset) begin
        q0 <= 4'd0;
        q1 <= 4'd0;
        q2 <= 4'd0;
        q3 <= 4'd0;
    end else begin
        if (q0 == 4'd9) begin
            q0 <= 4'd0;
            if (q1 == 4'd9) begin
                q1 <= 4'd0;
                if (q2 == 4'd9) begin
                    q2 <= 4'd0;
                    if (q3 == 4'd9) begin
                        q3 <= 4'd0;
                    end else begin
                        q3 <= q3 + 1;
                    end
                end else begin
                    q2 <= q2 + 1;
                end
            end else begin
                q1 <= q1 + 1;
            end
        end else begin
            q0 <= q0 + 1;
        end
    end
end

// Generate the enable signals
assign ena[0] = (q0 == 4'd9);
assign ena[1] = (q1 == 4'd9) && (q0 == 4'd9);
assign ena[2] = (q2 == 4'd9) && (q1 == 4'd9) && (q0 == 4'd9);

// Generate the output
assign q[3:0] = q0;
assign q[7:4] = q1;
assign q[11:8] = q2;
assign q[15:12] = q3;

endmodule