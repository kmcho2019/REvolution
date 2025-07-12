module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    reg [7:0] scancodes [0:9] = {
        8'h45, 8'h16, 8'h1e, 8'h26, 8'h25,
        8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
    };

    always @(*) begin
        valid = 1'b0;
        out = 4'h0;
        for (int i = 0; i < 10; i++) begin
            if (code == scancodes[i]) begin
                valid = 1'b1;
                out = i;
            end
        end
    end

endmodule