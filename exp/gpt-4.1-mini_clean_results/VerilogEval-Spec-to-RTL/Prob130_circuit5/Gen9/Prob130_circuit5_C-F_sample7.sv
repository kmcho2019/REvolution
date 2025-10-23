module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Combinational function for selecting q based on c
    function [3:0] select_q;
        input [3:0] c_sel;
        begin
            case (c_sel)
                4'd0: select_q = b;
                4'd1: select_q = e;
                4'd2: select_q = a;
                4'd3: select_q = d;
                default: select_q = 4'hF;
            endcase
        end
    endfunction

    assign q = select_q(c);

endmodule