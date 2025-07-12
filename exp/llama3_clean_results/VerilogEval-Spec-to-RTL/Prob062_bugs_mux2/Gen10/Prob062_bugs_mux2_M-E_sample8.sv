module top_module(
    input [7:0] a,
    input [7:0] b,
    input        sel,
    input        condition,
    output [7:0] out
);

    reg [7:0] temp_out;

    always @(*) begin
        if (condition) begin
            temp_out = a;
        end else if (sel) begin
            temp_out = b;
        end else begin
            temp_out = a;
        end
    end

    assign out = temp_out;

endmodule