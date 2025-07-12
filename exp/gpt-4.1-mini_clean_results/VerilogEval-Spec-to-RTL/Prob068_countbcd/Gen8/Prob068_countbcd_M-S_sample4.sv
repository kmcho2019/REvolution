module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] q_reg;

    // ena signals indicate when the lower digit rolls over 9
    assign ena[0] = (q_reg[3:0]  == 4'd9);
    assign ena[1] = (q_reg[7:4]  == 4'd9) && ena[0];
    assign ena[2] = (q_reg[11:8] == 4'd9) && ena[1];
    assign q = q_reg;

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 16'd0;
        end else begin
            // Increment ones digit
            if (q_reg[3:0] == 4'd9) begin
                q_reg[3:0] <= 4'd0;
                // Increment tens digit
                if (q_reg[7:4] == 4'd9) begin
                    q_reg[7:4] <= 4'd0;
                    // Increment hundreds digit
                    if (q_reg[11:8] == 4'd9) begin
                        q_reg[11:8] <= 4'd0;
                        // Increment thousands digit
                        if (q_reg[15:12] == 4'd9)
                            q_reg[15:12] <= 4'd0;
                        else
                            q_reg[15:12] <= q_reg[15:12] + 1'b1;
                    end else begin
                        q_reg[11:8] <= q_reg[11:8] + 1'b1;
                    end
                end else begin
                    q_reg[7:4] <= q_reg[7:4] + 1'b1;
                end
            end else begin
                q_reg[3:0] <= q_reg[3:0] + 1'b1;
            end
        end
    end

endmodule