module TopModule(
    input [99:0] in,
    output reg [99:0] out_both,
    output reg [99:0] out_any,
    output reg [99:0] out_different,
    input clk,
    input start
);
    reg [6:0] counter;
    reg [99:0] in_reg;
    
    always @(posedge clk) begin
        if (start) begin
            counter <= 0;
            in_reg <= in;
        end else if (counter < 100) begin
            // out_both logic
            if (counter == 99)
                out_both[99] <= 1'b0;
            else
                out_both[counter] <= in_reg[counter] & in_reg[counter+1];
            
            // out_any logic
            if (counter == 0)
                out_any[0] <= 1'b0;
            else
                out_any[counter] <= in_reg[counter] | in_reg[counter-1];
            
            // out_different logic (with wrap-around)
            if (counter == 99)
                out_different[99] <= in_reg[99] ^ in_reg[0];
            else
                out_different[counter] <= in_reg[counter] ^ in_reg[counter+1];
            
            counter <= counter + 1;
        end
    end
endmodule