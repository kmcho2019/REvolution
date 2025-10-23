module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena_reg <= 3'd0;
        end else begin
            // Increment ones digit (always enabled)
            if (counter[3:0] == 4'd9) begin
                counter[3:0] <= 4'd0;
                ena_reg[0] <= 1'b1;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
                ena_reg[0] <= 1'b0;
            end
            
            // Increment tens digit when enabled
            if (ena_reg[0]) begin
                if (counter[7:4] == 4'd9) begin
                    counter[7:4] <= 4'd0;
                    ena_reg[1] <= 1'b1;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                    ena_reg[1] <= 1'b0;
                end
            end else begin
                ena_reg[1] <= 1'b0;
            end
            
            // Increment hundreds digit when enabled
            if (ena_reg[1]) begin
                if (counter[11:8] == 4'd9) begin
                    counter[11:8] <= 4'd0;
                    ena_reg[2] <= 1'b1;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                    ena_reg[2] <= 1'b0;
                end
            end else begin
                ena_reg[2] <= 1'b0;
            end
            
            // Increment thousands digit when enabled
            if (ena_reg[2]) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
        end
    end
    
    assign q = counter;
    assign ena = ena_reg;

endmodule