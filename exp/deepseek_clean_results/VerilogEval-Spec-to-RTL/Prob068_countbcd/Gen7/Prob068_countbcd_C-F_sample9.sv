module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    
    // Combinational enable pre-calculation
    wire ones_rollover = (counter[3:0] == 4'd9);
    wire tens_rollover = (counter[7:4] == 4'd9);
    wire hundreds_rollover = (counter[11:8] == 4'd9);
    
    assign q = counter;
    assign ena = ena_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
            ena_reg <= 3'b0;
        end else begin
            // Register enable signals to break timing paths
            ena_reg[0] <= ones_rollover;
            ena_reg[1] <= tens_rollover & ena_reg[0];
            ena_reg[2] <= hundreds_rollover & ena_reg[1];
            
            // Ones digit always increments
            if (ones_rollover) begin
                counter[3:0] <= 4'd0;
            end else begin
                counter[3:0] <= counter[3:0] + 4'd1;
            end
            
            // Higher digits only update when needed
            if (ena_reg[0]) begin
                if (tens_rollover) begin
                    counter[7:4] <= 4'd0;
                end else begin
                    counter[7:4] <= counter[7:4] + 4'd1;
                end
            end
            
            if (ena_reg[1]) begin
                if (hundreds_rollover) begin
                    counter[11:8] <= 4'd0;
                end else begin
                    counter[11:8] <= counter[11:8] + 4'd1;
                end
            end
            
            if (ena_reg[2]) begin
                if (counter[15:12] == 4'd9) begin
                    counter[15:12] <= 4'd0;
                end else begin
                    counter[15:12] <= counter[15:12] + 4'd1;
                end
            end
        end
    end

endmodule