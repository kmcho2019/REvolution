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

// Function implementing 6-to-1 mux with zero output for out-of-range sel
function [3:0] mux6to1;
    input [2:0] s;
    input [3:0] d0, d1, d2, d3, d4, d5;
    begin
        case (s)
            3'd0: mux6to1 = d0;
            3'd1: mux6to1 = d1;
            3'd2: mux6to1 = d2;
            3'd3: mux6to1 = d3;
            3'd4: mux6to1 = d4;
            3'd5: mux6to1 = d5;
            default: mux6to1 = 4'b0000;
        endcase
    end
endfunction

// Directly assign output from mux function (no extra range check)
assign out = mux6to1(sel, data0, data1, data2, data3, data4, data5);

endmodule