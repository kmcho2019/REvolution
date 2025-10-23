module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

parameter CONNECTION = 4'b1101; // a -> w, b -> x, b -> y, c -> z

genvar i;
generate
    for (i = 0; i < 4; i++) begin
        if (CONNECTION[i]) begin
            case (i)
                0: assign w = a;
                1: assign x = b;
                2: assign y = b;
                3: assign z = c;
            endcase
        end
    end
endgenerate

endmodule