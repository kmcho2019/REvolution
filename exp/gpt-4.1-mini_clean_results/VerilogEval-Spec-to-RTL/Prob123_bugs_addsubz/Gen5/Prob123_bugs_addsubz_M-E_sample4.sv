module TopModule (
    input  wire        do_sub,
    input  wire [7:0]  a,
    input  wire [7:0]  b,
    output reg  [7:0]  out,
    output reg         result_is_zero
);

    reg [7:0] result;

    always @(*) begin
        if (do_sub) begin
            result = a + (~b) + 1; // two's complement subtraction
        end else begin
            result = a + b;
        end

        out = result;
        result_is_zero = (result == 8'd0);
    end

endmodule