module TopModule (
    input  wire a,
    input  wire b,
    input  wire c,
    output wire w,
    output wire x,
    output wire y,
    output wire z
);

    // Select constants (fixed selects for multiplexers)
    localparam SEL_A = 2'd0;
    localparam SEL_B = 2'd1;
    localparam SEL_C = 2'd2;

    // 2-bit input selector for each output mux
    // w = a
    assign w = mux3(SEL_A, a, b, c);
    // x = b
    assign x = mux3(SEL_B, a, b, c);
    // y = b
    assign y = mux3(SEL_B, a, b, c);
    // z = c
    assign z = mux3(SEL_C, a, b, c);

    // 3-to-1 multiplexer function selecting inputs based on select code
    function automatic mux3(
        input [1:0] sel,
        input in0,
        input in1,
        input in2
    );
        begin
            case (sel)
                2'd0: mux3 = in0;
                2'd1: mux3 = in1;
                2'd2: mux3 = in2;
                default: mux3 = 1'b0;
            endcase
        end
    endfunction

endmodule