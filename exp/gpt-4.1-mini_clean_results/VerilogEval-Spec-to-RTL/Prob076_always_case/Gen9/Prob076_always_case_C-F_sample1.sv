module TopModule (
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output [3:0] out
);

function [3:0] mux6to1;
    input [2:0] sel_f;
    begin
        case(sel_f)
            3'd0: mux6to1 = data0;
            3'd1: mux6to1 = data1;
            3'd2: mux6to1 = data2;
            3'd3: mux6to1 = data3;
            3'd4: mux6to1 = data4;
            3'd5: mux6to1 = data5;
            default: mux6to1 = 4'b0000;
        endcase
    end
endfunction

assign out = mux6to1(sel);

endmodule