module TopModule(
    input [254:0] in,
    output [7:0] out
);

// Count the number of '1's in a 3-bit vector
function [1:0] count_3bit;
    input [2:0] a;
    begin
        case(a)
            3'b000: count_3bit = 2'b00;
            3'b001, 3'b010, 3'b100: count_3bit = 2'b01;
            3'b011, 3'b101, 3'b110: count_3bit = 2'b10;
            3'b111: count_3bit = 2'b11;
        endcase
    end
endfunction

// Calculate the sum of two 2-bit numbers
function [3:0] add_2bit;
    input [1:0] a, b;
    begin
        add_2bit = a + b;
    end
endfunction

// Calculate the sum of 85 2-bit numbers in a hierarchical manner
reg [7:0] out_reg;
reg [3:0] sum_85 [84:0];
integer i, j, k;
always @(*) begin
    for (i = 0; i < 85; i = i + 1) begin
        sum_85[i] = count_3bit(in[3*i +: 3]);
    end
    out_reg = 8'd0;
    for (i = 0; i < 85; i = i + 1) begin
        out_reg = out_reg + {1'b0, sum_85[i][1:0]};
    end
end

assign out = out_reg;

endmodule