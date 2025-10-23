module TopModule(
    input [3:0] in,
    output reg [1:0] pos
);

    integer i;

    always @(in) begin
        pos = 2'b00; // default value
        for (i = 3; i >= 0; i = i - 1) begin
            if (in[i] == 1'b1) begin
                case (i)
                    3: pos = 2'b11;
                    2: pos = 2'b10;
                    1: pos = 2'b01;
                    0: pos = 2'b00;
                endcase
                break;
            end
        end
    end

endmodule