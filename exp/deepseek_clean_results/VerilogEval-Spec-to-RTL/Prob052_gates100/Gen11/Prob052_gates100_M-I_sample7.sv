module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Parameterized reduction module
    module reduction #(parameter WIDTH = 100, parameter OP = "AND") (
        input [WIDTH-1:0] data,
        output result
    );
        generate
            if (WIDTH == 1) begin
                assign result = data;
            end
            else if (WIDTH == 2) begin
                if (OP == "AND") assign result = data[0] & data[1];
                else if (OP == "OR") assign result = data[0] | data[1];
                else if (OP == "XOR") assign result = data[0] ^ data[1];
            end
            else begin
                localparam LHALF = WIDTH/2;
                localparam RHALF = WIDTH - LHALF;
                wire res_l, res_r;
                reduction #(LHALF, OP) left(data[LHALF-1:0], res_l);
                reduction #(RHALF, OP) right(data[WIDTH-1:LHALF], res_r);
                
                if (OP == "AND") assign result = res_l & res_r;
                else if (OP == "OR") assign result = res_l | res_r;
                else if (OP == "XOR") assign result = res_l ^ res_r;
            end
        endgenerate
    endmodule

    // Instantiate reduction modules for each operation
    reduction #(100, "AND") and_reduce(in, out_and);
    reduction #(100, "OR") or_reduce(in, out_or);
    reduction #(100, "XOR") xor_reduce(in, out_xor);

endmodule