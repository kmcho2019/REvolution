module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Function to select output based on c
    function [3:0] select_q;
        input [3:0] c_val;
        begin
            case (c_val)
                4'h0: select_q = b;
                4'h1: select_q = e;
                4'h2: select_q = a;
                4'h3: select_q = d;
                default: select_q = 4'hF;
            endcase
        end
    endfunction

    always @(*) begin
        q = select_q(c);
    end

endmodule