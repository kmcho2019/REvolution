module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 0;
        shift_ena <= 1'b1;
    end else begin
        if (count < 4) begin
            count <= count + 1;
            shift_ena <= 1'b1;
        end else begin
            shift_ena <= 1'b0;
        end
    end
end

endmodule