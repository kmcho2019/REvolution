module TopModule(
    input  [7:0] code,
    output [3:0] out,
    output valid
);

    localparam [7:0] scancodes [0:9] = {
        8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
    };

    reg [3:0] out_reg;
    reg valid_reg;

    always @(*) begin
        out_reg = 4'd0;
        valid_reg = 1'b0;

        for (int i = 0; i < 10; i++) begin
            if (code == scancodes[i]) begin
                out_reg = i;
                valid_reg = 1'b1;
                break;
            end
        end
    end

    assign out = out_reg;
    assign valid = valid_reg;

endmodule