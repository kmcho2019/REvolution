module LatchModule(input en, input ar, input d, output reg q);
    always @(*) if (ar) q <= 0; else if (en) q <= d;
endmodule

module TopModule(input clk, input ar, input d, output q);
    wire master_out;
    LatchModule master(~clk, ar, d, master_out);
    LatchModule slave(clk, ar, master_out, q);
endmodule