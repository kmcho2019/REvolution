module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] count;

always @ (posedge clk) begin
    if (reset) begin
        shift_ena <= 1;
        count <= 1;
    end else if (count < 4) begin
        shift_ena <= 1;
        count <= count + 1;
    end else begin
        shift_ena <= 0;
        count <= 0;
    end
end

endmodule