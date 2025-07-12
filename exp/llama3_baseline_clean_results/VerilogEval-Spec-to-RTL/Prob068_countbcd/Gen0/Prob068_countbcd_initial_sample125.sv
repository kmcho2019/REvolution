module BCDCounter(
    input clk,
    input reset,
    input ena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 4'd0;
    end else if (ena) begin
        if (q == 4'd9) begin
            q <= 4'd0;
        end else begin
            q <= q + 1;
        end
    end
end

endmodule

module TopModule(
    input clk,
    input reset,
    output reg [2:0] ena,
    output reg [15:0] q
);

reg [3:0] q0, q1, q2, q3;

always @(posedge clk) begin
    if (reset) begin
        q0 <= 4'd0;
        q1 <= 4'd0;
        q2 <= 4'd0;
        q3 <= 4'd0;
    end else begin
        ena[0] <= (q0 == 4'd9);
        ena[1] <= (q1 == 4'd9 && q0 == 4'd0);
        ena[2] <= (q2 == 4'd9 && q1 == 4'd0 && q0 == 4'd0);
        
        if (q0 == 4'd9) begin
            q0 <= 4'd0;
        end else begin
            q0 <= q0 + 1;
        end
        
        if (ena[0] && q1 == 4'd9) begin
            q1 <= 4'd0;
        end else if (ena[0]) begin
            q1 <= q1 + 1;
        end
        
        if (ena[1] && q2 == 4'd9) begin
            q2 <= 4'd0;
        end else if (ena[1]) begin
            q2 <= q2 + 1;
        end
        
        if (ena[2] && q3 == 4'd9) begin
            q3 <= 4'd0;
        end else if (ena[2]) begin
            q3 <= q3 + 1;
        end
    end
end

assign q[3:0] = q0;
assign q[7:4] = q1;
assign q[11:8] = q2;
assign q[15:12] = q3;

endmodule