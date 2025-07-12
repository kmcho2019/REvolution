module TopModule(
    input  [254:0] in,
    output [7:0] out
);

    reg [7:0] out;

    always @(in) begin
        out = 8'd0;
        for (int i = 0; i < 255; i++) begin
            out = out + in[i];
        end
    end

endmodule