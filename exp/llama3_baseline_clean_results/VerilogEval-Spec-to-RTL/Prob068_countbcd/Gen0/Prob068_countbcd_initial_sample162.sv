module TopModule(
    input clk,
    input reset,
    output [2:0] ena,
    output [15:0] q
);

reg [3:0] digit1, digit2, digit3, digit4;
assign q = {digit4, digit3, digit2, digit1};
reg [2:0] ena_temp;

always @(posedge clk) begin
    if(reset) begin
        digit1 <= 0;
        digit2 <= 0;
        digit3 <= 0;
        digit4 <= 0;
    end else begin
        ena_temp <= 3'b000;
        if(digit1 == 4'd9) begin
            ena_temp[0] <= 1'b1;
            digit1 <= 0;
            if(digit2 == 4'd9) begin
                ena_temp[1] <= 1'b1;
                digit2 <= 0;
                if(digit3 == 4'd9) begin
                    ena_temp[2] <= 1'b1;
                    digit3 <= 0;
                    digit4 <= digit4 + 1;
                end else begin
                    digit3 <= digit3 + 1;
                end
            end else begin
                digit2 <= digit2 + 1;
            end
        end else begin
            digit1 <= digit1 + 1;
        end
    end
end

assign ena = ena_temp;

endmodule