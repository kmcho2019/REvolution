module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [99:0] q
);

reg [6:0] counter;
reg [99:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
        counter <= 0;
    end else begin
        case (ena)
            2'b01: counter <= (counter + 1) % 100;
            2'b10: counter <= (counter - 1 + 100) % 100;
            default: counter <= counter;
        endcase
    end
end

always @(*) begin
    for (int i = 0; i < 100; i++) begin
        q[i] = q_reg[(i + counter) % 100];
    end
end

endmodule