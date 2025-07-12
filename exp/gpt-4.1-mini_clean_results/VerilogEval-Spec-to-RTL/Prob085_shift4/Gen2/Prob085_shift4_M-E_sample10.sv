module TopModule(
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] shift_reg;

// Asynchronous reset process
always @(posedge areset or posedge clk) begin
    if (areset) begin
        shift_reg <= 4'b0;
    end else begin
        if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            shift_reg <= {1'b0, shift_reg[3:1]};
        end
    end
end

assign q = shift_reg;

endmodule