module TopModule(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [99:0] data_reg;
reg [6:0] rotation_counter;

always @(posedge clk) begin
    if (load) begin
        data_reg <= data;
        rotation_counter <= 0;
    end else begin
        case (ena)
            2'b01: rotation_counter <= rotation_counter - 1;
            2'b10: rotation_counter <= rotation_counter + 1;
            default: rotation_counter <= rotation_counter;
        endcase
    end
end

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        q[i] = data_reg[(i + rotation_counter) % 100];
    end
end

endmodule