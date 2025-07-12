module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    // Define an array of known scancodes for digits 0 through 9
    reg [7:0] scancodes [0:9];
    integer i;

    initial begin
        scancodes[0] = 8'h45; // 0
        scancodes[1] = 8'h16; // 1
        scancodes[2] = 8'h1e; // 2
        scancodes[3] = 8'h26; // 3
        scancodes[4] = 8'h25; // 4
        scancodes[5] = 8'h2e; // 5
        scancodes[6] = 8'h36; // 6
        scancodes[7] = 8'h3d; // 7
        scancodes[8] = 8'h3e; // 8
        scancodes[9] = 8'h46; // 9
    end

    always @(*) begin
        valid = 0;
        out = 4'd0;
        for (i = 0; i < 10; i = i + 1) begin
            if (code == scancodes[i]) begin
                valid = 1'b1;
                out = i[3:0];
            end
        end
    end

endmodule