module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [3:0] shift_reg;
reg detected;

always @(posedge clk) begin
    if(reset) begin
        shift_reg <= 4'b0000;
        detected <= 0;
    end else begin
        shift_reg <= {shift_reg[2:0], data};
        if(shift_reg == 4'b1101 && !detected) begin
            detected <= 1;
        end
    end
end

assign start_shifting = detected;

endmodule