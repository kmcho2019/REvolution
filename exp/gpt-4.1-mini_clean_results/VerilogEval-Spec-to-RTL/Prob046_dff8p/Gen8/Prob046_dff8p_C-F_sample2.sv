module DFF_SyncResetNegEdge (
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    // Hardcoded synchronous reset value bit from 0x34 = 8'b00110100
    // Define a parameter RESET_BIT for flexibility in future reuse
    parameter RESET_BIT = 1'b0;  // will be overridden per instance

    always @(negedge clk) begin
        if (reset)
            q <= RESET_BIT;
        else
            q <= d;
    end
endmodule

module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    // 0x34 in binary: bit7=0, bit6=0, bit5=1, bit4=1, bit3=0, bit2=1, bit1=0, bit0=0
    // Indexing from LSB=bit0 to MSB=bit7
    localparam [7:0] RESET_VAL = 8'h34;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_array
            // Instantiate each DFF with its corresponding reset bit as parameter
            DFF_SyncResetNegEdge #(.RESET_BIT(RESET_VAL[i])) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule