module TopModule (
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] q_reg;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q_reg <= 16'd0;
        ena <= 3'd0;
    end else begin
        ena <= 3'd0; // default to not enabling any digit

        // ones digit
        if (q_reg[3:0] == 4'd9) begin
            q_reg[3:0] <= 4'd0;
            ena[0] <= 1'b1; // enable tens digit to be incremented
        end else begin
            q_reg[3:0] <= q_reg[3:0] + 1'd1;
        end

        // tens digit
        if (q_reg[3:0] == 4'd0 && ena[0] == 1'b1) begin
            if (q_reg[7:4] == 4'd9) begin
                q_reg[7:4] <= 4'd0;
                ena[1] <= 1'b1; // enable hundreds digit to be incremented
            end else begin
                q_reg[7:4] <= q_reg[7:4] + 1'd1;
            end
            ena[0] <= 1'b0;
        end

        // hundreds digit
        if (q_reg[7:4] == 4'd0 && ena[1] == 1'b1) begin
            if (q_reg[11:8] == 4'd9) begin
                q_reg[11:8] <= 4'd0;
                ena[2] <= 1'b1; // enable thousands digit to be incremented
            end else begin
                q_reg[11:8] <= q_reg[11:8] + 1'd1;
            end
            ena[1] <= 1'b0;
        end

        // thousands digit
        if (q_reg[11:8] == 4'd0 && ena[2] == 1'b1) begin
            if (q_reg[15:12] == 4'd9) begin
                q_reg[15:12] <= 4'd0;
            end else begin
                q_reg[15:12] <= q_reg[15:12] + 1'd1;
            end
            ena[2] <= 1'b0;
        end
    end
end

assign q = q_reg;

endmodule