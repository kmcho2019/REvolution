module TopModule (
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

    reg [15:0] counter;
    reg [2:0] ena_reg;
    
    // Main counter logic
    always @(posedge clk) begin
        if (reset) begin
            counter <= 16'd0;
        end else begin
            if (counter == 16'd9999) begin
                counter <= 16'd0;
            end else begin
                counter <= counter + 16'd1;
            end
        end
    end
    
    // BCD digit extraction
    assign q[3:0] = counter % 10;                   // Ones digit
    assign q[7:4] = (counter / 10) % 10;            // Tens digit
    assign q[11:8] = (counter / 100) % 10;          // Hundreds digit
    assign q[15:12] = (counter / 1000) % 10;        // Thousands digit
    
    // Enable generation
    always @(posedge clk) begin
        if (reset) begin
            ena_reg <= 3'b0;
        end else begin
            // Ones digit enable (always enabled)
            ena_reg[0] <= (q[3:0] == 4'd9);
            
            // Tens digit enable (when ones digit rolls over)
            ena_reg[1] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9);
            
            // Hundreds digit enable (when tens and ones roll over)
            ena_reg[2] <= (q[3:0] == 4'd9) && (q[7:4] == 4'd9) && (q[11:8] == 4'd9);
        end
    end
    
    assign ena = ena_reg;

endmodule