module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    reg [99:0] temp_out;

    always @(*) begin
        for (int i = 0; i < 100; i++) begin
            temp_out[i] = in[99 - i];
        end
    end

    assign out = temp_out;

endmodule