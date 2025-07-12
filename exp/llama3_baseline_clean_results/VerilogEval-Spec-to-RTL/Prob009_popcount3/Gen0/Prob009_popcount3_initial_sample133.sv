module TopModule(
    input [2:0] in,
    output reg [1:0] out
);

    always @(*) begin
        if (in[0] + in[1] + in[2] == 3) begin
            out = 2'b11; // count is 3
        end else if (in[0] + in[1] + in[2] == 2) begin
            out = 2'b10; // count is 2
        end else if (in[0] + in[1] + in[2] == 1) begin
            out = 2'b01; // count is 1
        end else begin
            out = 2'b00; // count is 0
        end
    end

endmodule