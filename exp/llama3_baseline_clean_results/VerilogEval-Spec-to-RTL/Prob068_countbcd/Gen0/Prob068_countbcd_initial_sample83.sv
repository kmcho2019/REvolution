module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] q_reg;
    reg [2:0] ena_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q_reg <= 16'd0;
            ena_reg <= 3'b0;
        end else begin
            ena_reg <= 3'b0;
            if (q_reg == 16'd9999) begin
                q_reg <= 16'd0;
            end else begin
                if (q_reg[3:0] == 4'd9) begin
                    q_reg[3:0] <= 4'd0;
                    ena_reg[0] <= 1'b1;
                    if (q_reg[7:4] == 4'd9) begin
                        q_reg[7:4] <= 4'd0;
                        ena_reg[1] <= 1'b1;
                        if (q_reg[11:8] == 4'd9) begin
                            q_reg[11:8] <= 4'd0;
                            ena_reg[2] <= 1'b1;
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
    end

    assign ena = ena_reg;
    assign q = q_reg;

endmodule