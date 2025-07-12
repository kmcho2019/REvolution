module TopModule(
    input clk,
    input reset,
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
        if (q_reg[3:0] == 4'd9) begin // ones digit is at maximum
            q_reg[3:0] <= 4'd0;
            ena_reg[0] <= 1'b1;
            if (q_reg[7:4] == 4'd9) begin // tens digit is at maximum
                q_reg[7:4] <= 4'd0;
                ena_reg[1] <= 1'b1;
                if (q_reg[11:8] == 4'd9) begin // hundreds digit is at maximum
                    q_reg[11:8] <= 4'd0;
                    ena_reg[2] <= 1'b1;
                    q_reg[15:12] <= q_reg[15:12] + 1'b1; // increment thousands digit
                end else begin
                    q_reg[11:8] <= q_reg[11:8] + 1'b1; // increment hundreds digit
                    ena_reg[2] <= 1'b0;
                end
            end else begin
                q_reg[7:4] <= q_reg[7:4] + 1'b1; // increment tens digit
                ena_reg[1] <= 1'b0;
                ena_reg[2] <= 1'b0;
            end
        end else begin
            q_reg[3:0] <= q_reg[3:0] + 1'b1; // increment ones digit
            ena_reg[0] <= 1'b0;
            ena_reg[1] <= 1'b0;
            ena_reg[2] <= 1'b0;
        end
    end
end

assign q = q_reg;
assign ena = ena_reg;

endmodule