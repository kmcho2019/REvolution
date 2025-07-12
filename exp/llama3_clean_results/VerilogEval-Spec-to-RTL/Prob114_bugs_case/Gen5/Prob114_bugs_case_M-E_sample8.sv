module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] scancodes [9:0];
    initial begin
        scancodes[0] = 4'd0;
        scancodes[1] = 4'd1;
        scancodes[2] = 4'd2;
        scancodes[3] = 4'd3;
        scancodes[4] = 4'd4;
        scancodes[5] = 4'd5;
        scancodes[6] = 4'd6;
        scancodes[7] = 4'd7;
        scancodes[8] = 4'd8;
        scancodes[9] = 4'd9;
    end

    always @(*) begin
        out = 4'd0;
        valid = 1'b0;
        for (int i = 0; i < 10; i++) begin
            if (code == 8'h45 + i * 8'h1 + (i >= 5 ? 8'h10 : 8'h0)) begin
                out = scancodes[i];
                valid = 1'b1;
            end
        end
    end

endmodule