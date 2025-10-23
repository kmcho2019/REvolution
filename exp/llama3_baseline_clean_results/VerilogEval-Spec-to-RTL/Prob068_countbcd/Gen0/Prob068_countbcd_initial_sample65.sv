module TopModule(
    input       clk,
    input       reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] q0;
    reg [3:0] q1;
    reg [3:0] q2;
    reg [3:0] q3;

    assign q = {q3, q2, q1, q0};

    always @(posedge clk or posedge reset) begin
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

    always @(*) begin
        if (q0 == 4'd9 && q1 < 4'd9 && q2 < 4'd9 && q3 < 4'd9) begin
            ena[0] = 1'b1;
        end else begin
            ena[0] = 1'b0;
        end
        if (q1 == 4'd9 && q2 < 4'd9 && q3 < 4'd9) begin
            ena[1] = 1'b1;
        end else begin
            ena[1] = 1'b0;
        end
        if (q2 == 4'd9 && q3 < 4'd9) begin
            ena[2] = 1'b1;
        end else begin
            ena[2] = 1'b0;
        end
    end

endmodule