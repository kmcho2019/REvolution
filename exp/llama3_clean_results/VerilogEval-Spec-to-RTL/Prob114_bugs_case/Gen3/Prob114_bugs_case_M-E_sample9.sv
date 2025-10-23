module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [7:0] scancodes[10] = '{8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46};
    reg [3:0] keys[10] = '{4'd0, 4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6, 4'd7, 4'd8, 4'd9};
    integer i;

    always @(*) begin
        valid = 1'b0;
        out = 4'd0;
        for (i = 0; i < 10; i = i + 1) begin
            if (code == scancodes[i]) begin
                out = keys[i];
                valid = 1'b1;
                break;
            end
        end
    end

endmodule