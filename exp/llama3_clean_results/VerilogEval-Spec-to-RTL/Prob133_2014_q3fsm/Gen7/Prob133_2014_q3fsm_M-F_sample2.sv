module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] counter;
reg [2:0] w_reg;
reg [1:0] w_count;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        counter <= 2'b00;
        w_reg <= 3'b000;
        w_count <= 2'b00;
    end else begin
        if(s && counter == 2'b00) begin
            counter <= 2'b01;
            w_reg <= 3'b000;
            w_count <= 2'b00;
        end else if(counter > 2'b00 && counter < 2'b11) begin
            counter <= counter + 1;
            w_reg <= {w_reg[1:0], w};
            w_count <= w_count + (w ? 1 : 0);
        end else if(counter == 2'b11) begin
            counter <= 2'b01;
            w_reg <= 3'b000;
            w_count <= 2'b00;
        end
    end
end

always @(posedge clk) begin
    if(counter == 2'b11) begin
        z <= (w_count == 2) ? 1'b1 : 1'b0;
    end else begin
        z <= 1'b0;
    end
end

endmodule