module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output z
);

reg [2:0] w_reg; // Shift register to store 'w' values
reg [1:0] counter; // Counter to keep track of clock cycles

assign z = (counter == 3) && (w_reg == 3'b110 || w_reg == 3'b101 || w_reg == 3'b011);

always @(posedge clk) begin
    if(reset) begin
        w_reg <= 0;
        counter <= 0;
    end
    else begin
        if(s && counter == 0) begin
            counter <= 1;
        end
        else if(counter > 0 && counter < 3) begin
            counter <= counter + 1;
        end
        else if(counter == 3) begin
            counter <= 1;
        end
        w_reg <= {w, w_reg[2:1]};
    end
end

endmodule