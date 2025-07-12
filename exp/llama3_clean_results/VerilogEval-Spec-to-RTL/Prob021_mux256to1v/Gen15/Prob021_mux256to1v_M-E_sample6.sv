module TopModule #(
    parameter WIDTH = 4,
    parameter NUM_INPUTS = 256
)(
    input  [WIDTH * NUM_INPUTS - 1:0] in,
    input  [$clog2(NUM_INPUTS)-1:0] sel,
    output [WIDTH-1:0] out
);

    always @(in, sel) begin
        case (sel)
            0: out = in[WIDTH-1:0];
            1: out = in[WIDTH*2-1:WIDTH];
            // ...
            NUM_INPUTS-2: out = in[WIDTH*(NUM_INPUTS-1)-1:WIDTH*(NUM_INPUTS-2)];
            NUM_INPUTS-1: out = in[WIDTH*NUM_INPUTS-1:WIDTH*(NUM_INPUTS-1)];
            default: out = '0;
        endcase
    end

endmodule

// To avoid having to write out 256 cases by hand, we can use a loop to generate the case statement
module TopModule #(
    parameter WIDTH = 4,
    parameter NUM_INPUTS = 256
)(
    input  [WIDTH * NUM_INPUTS - 1:0] in,
    input  [$clog2(NUM_INPUTS)-1:0] sel,
    output [WIDTH-1:0] out
);

    always @(in, sel) begin
        case (sel)
            default: out = '0;
            for (genvar i = 0; i < NUM_INPUTS; i++) begin
                i: out = in[WIDTH*i +: WIDTH];
            end
        endcase
    end

endmodule