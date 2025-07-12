// Module to compute out_both
module BothModule(
    input  [3:0] in,
    output [3:0] out_both
);

    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            if (i < 3) begin
                out_both[i] = in[i] & in[i+1];
            end else begin
                out_both[i] = 1'b0;
            end
        end
    end

endmodule

// Module to compute out_any
module AnyModule(
    input  [3:0] in,
    output [3:0] out_any
);

    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            if (i > 0) begin
                out_any[i] = in[i] | in[i-1];
            end else begin
                out_any[i] = in[i];
            end
        end
    end

endmodule

// Module to compute out_different
module DifferentModule(
    input  [3:0] in,
    output [3:0] out_different
);

    always @(*) begin
        for (int i = 0; i < 4; i++) begin
            if (i == 0) begin
                out_different[i] = in[i] ^ in[3];
            end else begin
                out_different[i] = in[i] ^ in[i-1];
            end
        end
    end

endmodule

// Top module
module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    BothModule both_module(
       .in(in),
       .out_both(out_both)
    );

    AnyModule any_module(
       .in(in),
       .out_any(out_any)
    );

    DifferentModule different_module(
       .in(in),
       .out_different(out_different)
    );

endmodule