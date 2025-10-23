module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [3:0] digit [0:3];  // 4 digits: ones, tens, hundreds, thousands
    reg [2:0] ena_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            digit[0] <= 4'd0;
            digit[1] <= 4'd0;
            digit[2] <= 4'd0;
            digit[3] <= 4'd0;
            ena_reg <= 3'b0;
        end else begin
            // Ones digit (always increments)
            if (digit[0] == 4'd9) begin
                digit[0] <= 4'd0;
                ena_reg[0] <= 1'b1;
            end else begin
                digit[0] <= digit[0] + 4'd1;
                ena_reg[0] <= 1'b0;
            end
            
            // Tens digit (increments when ones rolls over)
            if (ena_reg[0]) begin
                if (digit[1] == 4'd9) begin
                    digit[1] <= 4'd0;
                    ena_reg[1] <= 1'b1;
                end else begin
                    digit[1] <= digit[1] + 4'd1;
                    ena_reg[1] <= 1'b0;
                end
            end else begin
                ena_reg[1] <= 1'b0;
            end
            
            // Hundreds digit (increments when tens rolls over)
            if (ena_reg[1]) begin
                if (digit[2] == 4'd9) begin
                    digit[2] <= 4'd0;
                    ena_reg[2] <= 1'b1;
                end else begin
                    digit[2] <= digit[2] + 4'd1;
                    ena_reg[2] <= 1'b0;
                end
            end else begin
                ena_reg[2] <= 1'b0;
            end
            
            // Thousands digit (increments when hundreds rolls over)
            if (ena_reg[2]) begin
                if (digit[3] == 4'd9) begin
                    digit[3] <= 4'd0;
                end else begin
                    digit[3] <= digit[3] + 4'd1;
                end
            end
        end
    end

    assign q = {digit[3], digit[2], digit[1], digit[0]};
    assign ena = ena_reg;

endmodule