module TopModule (
    input  [15:0] a,
    input  [15:0] b,
    input  [15:0] c,
    input  [15:0] d,
    input  [15:0] e,
    input  [15:0] f,
    input  [15:0] g,
    input  [15:0] h,
    input  [15:0] i,
    input  [3:0]  sel,
    output [15:0] out
);

    // Function to select input based on sel, default to 16'hFFFF for sel>8
    function [15:0] mux9to1;
        input [3:0] sel_func;
        begin
            case (sel_func)
                4'd0: mux9to1 = a;
                4'd1: mux9to1 = b;
                4'd2: mux9to1 = c;
                4'd3: mux9to1 = d;
                4'd4: mux9to1 = e;
                4'd5: mux9to1 = f;
                4'd6: mux9to1 = g;
                4'd7: mux9to1 = h;
                4'd8: mux9to1 = i;
                default: mux9to1 = 16'hFFFF;
            endcase
        end
    endfunction

    assign out = mux9to1(sel);

endmodule