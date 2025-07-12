module Latch(input en, input ar, input d, output reg q);
    always @(en or ar or d)
        if (ar) q <= 0;
        else if (en) q <= d;
endmodule

module TopModule(input clk, input ar, input d, output q);
    wire master_out;
    
    Latch master(
        .en(~clk),
        .ar(ar),
        .d(d),
        .q(master_out)
    );
    
    Latch slave(
        .en(clk),
        .ar(ar),
        .d(master_out),
        .q(q)
    );
endmodule