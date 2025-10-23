module TopModule (
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output reg [3:0] q
);

    // Function to select output q based on input c
    function [3:0] select_output;
        input [3:0] sel;
        begin
            case (sel)
                4'd0: select_output = b;
                4'd1: select_output = e;
                4'd2: select_output = a;
                4'd3: select_output = d;
                default: select_output = 4'hF;
            endcase
        end
    endfunction

    always @(*) begin
        q = select_output(c);
    end

endmodule