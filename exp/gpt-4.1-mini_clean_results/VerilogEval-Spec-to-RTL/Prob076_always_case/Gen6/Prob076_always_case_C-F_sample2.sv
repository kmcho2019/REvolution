module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

    // Function encapsulating 6-to-1 multiplexer logic with default zero output
    function [3:0] mux6to1_func;
        input [2:0] sel_f;
        input [3:0] d0, d1, d2, d3, d4, d5;
        begin
            case (sel_f)
                3'd0: mux6to1_func = d0;
                3'd1: mux6to1_func = d1;
                3'd2: mux6to1_func = d2;
                3'd3: mux6to1_func = d3;
                3'd4: mux6to1_func = d4;
                3'd5: mux6to1_func = d5;
                default: mux6to1_func = 4'b0000;
            endcase
        end
    endfunction

    // Combinational block assigns output using the mux function
    always @(*) begin
        out = mux6to1_func(sel, data0, data1, data2, data3, data4, data5);
    end

endmodule