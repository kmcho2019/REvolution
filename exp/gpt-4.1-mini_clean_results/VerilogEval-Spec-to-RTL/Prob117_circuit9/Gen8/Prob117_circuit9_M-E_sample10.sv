module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

// modulo-7 increment function 
function [2:0] mod7_inc;
    input [2:0] val;
    reg [3:0] tmp;
    begin
        tmp = val + 1;
        if (tmp == 7)
            mod7_inc = 3'd0;
        else
            mod7_inc = tmp[2:0];
    end
endfunction

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;
    end else begin
        q <= mod7_inc(q);
    end
end

endmodule