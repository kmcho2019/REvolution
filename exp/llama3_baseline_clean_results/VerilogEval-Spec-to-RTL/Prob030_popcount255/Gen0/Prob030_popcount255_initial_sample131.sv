module TopModule(
    input [254:0] in,
    output reg [7:0] out
);

    reg [7:0] count;

    always @(in) begin
        count = 8'b0;
        for (int i = 0; i < 255; i++) begin
            if (in[i])
                count = count + 1;
        end
        out = count;
    end

endmodule