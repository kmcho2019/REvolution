module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter;
reg [2:0] w_reg;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        counter <= 2'b00;
        w_reg <= 3'b000;
    end else begin
        if(s && counter == 2'b00) begin
            counter <= 2'b01;
        end else if(counter > 2'b00 && counter < 2'b11) begin
            counter <= counter + 1;
        end else if(counter == 2'b11) begin
            counter <= 2'b01;
        end
        w_reg <= {w_reg[1:0], w};
    end
end

always @(*) begin
    if(counter == 2'b11) begin
        z = (w_reg[2:1] == 2'b10 || w_reg[2:1] == 2'b01 || w_reg[1:0] == 2'b10) ? 1'b1 : 1'b0;
    end else begin
        z = 1'b0;
    end
end

endmodule