module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Combinational function returning q based on c
    function [3:0] select_q;
        input [3:0] a_in, b_in, c_in, d_in, e_in;
        begin
            case (c_in)
                4'd0: select_q = b_in;
                4'd1: select_q = e_in;
                4'd2: select_q = a_in;
                4'd3: select_q = d_in;
                default: select_q = 4'hF;
            endcase
        end
    endfunction

    assign q = select_q(a, b, c, d, e);

endmodule