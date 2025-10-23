module TopModule(
    input  [1023:0] in,
    input  [7:0] sel,
    output [3:0] out
);

    wire [3:0] block_sel = sel[7:4];
    wire [3:0] addr = sel[3:0];

    // Calculate the address of the selected 4-bit output
    wire [9:0] addr_calc = {block_sel, addr};

    // Use a single, large case statement to perform the multiplexing
    always @(*) begin
        case (addr_calc)
            4'd0: out = in[3:0];
            4'd1: out = in[7:4];
            4'd2: out = in[11:8];
            //...
            // 256 possible cases
            //...
            4'd255: out = in[1019:1016];
            default: out = 4'b0;
        endcase
    end

    // Alternatively, use a casex statement for more flexibility
    // always @(*) begin
    //     casex (addr_calc)
    //         4'd0: out = in[3:0];
    //         4'd1: out = in[7:4];
    //         //...
    //         // 256 possible cases
    //         //...
    //         4'd255: out = in[1019:1016];
    //         default: out = 4'b0;
    //     endcase
    // end

endmodule