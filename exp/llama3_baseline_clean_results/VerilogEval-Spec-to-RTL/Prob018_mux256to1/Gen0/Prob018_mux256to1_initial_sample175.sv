module TopModule(
    input [255:0] in,
    input [7:0] sel,
    output out
);

    always @(*) begin
        case(sel)
            256'd0: out = in[0];
            256'd1: out = in[1];
            256'd2: out = in[2];
            // ...
            // This approach is impractical for large numbers of cases.
            // A more practical solution is to use a continuous assign statement
            // with bit selection based on the sel value.
        endcase
    end

    // A more practical solution
    assign out = in[sel];

endmodule