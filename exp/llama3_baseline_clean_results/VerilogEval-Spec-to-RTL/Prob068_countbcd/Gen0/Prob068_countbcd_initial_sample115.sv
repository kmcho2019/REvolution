module TopModule(
    input  clk,
    input  reset,
    output [2:0] ena,
    output [15:0] q
);

reg [15:0] q_reg;
reg [2:0] ena_reg;

always @(posedge clk) begin
    if (reset) begin
        q_reg <= 16'd0;
        ena_reg <= 3'b000;
    end else begin
        // Calculate enable signals
        ena_reg[0] <= q_reg[3:0] == 4'd9; // Enable tens digit when ones digit is 9
        ena_reg[1] <= q_reg[7:4] == 4'd9 && q_reg[3:0] == 4'd9; // Enable hundreds digit when tens and ones digits are 9
        ena_reg[2] <= q_reg[11:8] == 4'd9 && q_reg[7:4] == 4'd9 && q_reg[3:0] == 4'd9; // Enable thousands digit when hundreds, tens, and ones digits are 9

        // Increment counter
        if (q_reg[3:0] == 4'd9) begin
            q_reg[3:0] <= 4'd0;
            if (q_reg[7:4] == 4'd9) begin
                q_reg[7:4] <= 4'd0;
                if (q_reg[11:8] == 4'd9) begin
                    q_reg[11:8] <= 4'd0;
                    if (q_reg[15:12] == 4'd9) begin
                        q_reg[15:12] <= 4'd0;
                    end else begin
                        q_reg[15:12] <= q_reg[15:12] + 1;
                    end
                end else begin
                    q_reg[11:8] <= q_reg[11:8] + 1;
                end
            end else begin
                q_reg[7:4] <= q_reg[7:4] + 1;
            end
        end else begin
            q_reg[3:0] <= q_reg[3:0] + 1;
        end
    end
end

assign q = q_reg;
assign ena = ena_reg;

endmodule