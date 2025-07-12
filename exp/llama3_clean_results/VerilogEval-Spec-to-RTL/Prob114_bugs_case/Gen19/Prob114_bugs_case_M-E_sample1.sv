module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg       valid
);

    reg [7:0] scancodes[10] = {
        8'h45, 8'h16, 8'h1e, 8'h26, 8'h25, 
        8'h2e, 8'h36, 8'h3d, 8'h3e, 8'h46
    };

    reg [3:0] outputs[10] = {
        4'h0, 4'h1, 4'h2, 4'h3, 4'h4, 
        4'h5, 4'h6, 4'h7, 4'h8, 4'h9
    };

    integer i;

    always @(*) begin
        valid = 1'b0;
        out = 4'h0;
        for (i = 0; i < 10; i = i + 1) begin
            if (code == scancodes[i]) begin
                out = outputs[i];
                valid = 1'b1;
                break;
            end
        end
    end

endmodule