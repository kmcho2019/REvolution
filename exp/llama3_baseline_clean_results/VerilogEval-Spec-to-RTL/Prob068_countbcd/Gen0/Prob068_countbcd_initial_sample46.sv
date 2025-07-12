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
        q_reg <= 16'b0;
        ena_reg <= 3'b0;
    end else begin
        // Initialize enable signals to 0
        ena_reg <= 3'b0;
        
        // Increment ones digit
        if (q_reg[3:0] == 4'b1001) begin
            q_reg[3:0] <= 4'b0;
            ena_reg[0] <= 1'b1; // Enable tens digit to increment
            if (q_reg[7:4] == 4'b1001) begin
                q_reg[7:4] <= 4'b0;
                ena_reg[1] <= 1'b1; // Enable hundreds digit to increment
                if (q_reg[11:8] == 4'b1001) begin
                    q_reg[11:8] <= 4'b0;
                    ena_reg[2] <= 1'b1; // Enable thousands digit to increment
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

assign q = q_reg;
assign ena = ena_reg;

endmodule