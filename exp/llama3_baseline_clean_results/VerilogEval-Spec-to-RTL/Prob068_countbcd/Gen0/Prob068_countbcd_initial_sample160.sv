module TopModule (
    input        clk,
    input        reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] q0, q1, q2, q3;
reg [2:0] ena_int;

always @(posedge clk) begin
    if (reset) begin
        q0 <= 0;
        q1 <= 0;
        q2 <= 0;
        q3 <= 0;
    end else begin
        if (q0 == 4'd9) begin
            q0 <= 0;
            if (q1 == 4'd9) begin
                q1 <= 0;
                if (q2 == 4'd9) begin
                    q2 <= 0;
                    q3 <= q3 + 1;
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

assign ena[0] = (q0 == 4'd9) && (q1 != 4'd9);
assign ena[1] = (q0 == 4'd9) && (q1 == 4'd9) && (q2 != 4'd9);
assign ena[2] = (q0 == 4'd9) && (q1 == 4'd9) && (q2 == 4'd9);

assign q = {q3, q2, q1, q0};

endmodule