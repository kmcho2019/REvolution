module DFF (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0; // reset bit is parameterized externally
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

    // Constant reset value 0x34 = 8'b00110100
    // We connect each bit of the reset value individually to each DFF
    wire [7:0] reset_val = 8'h34;

    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_array
            // Instantiate individual DFFs with reset set to reset_val[i]
            // We modify the DFF module to accept reset_val[i] as the reset state
            DFF_ResetVal #(.RESET_VAL(reset_val[i])) dff_inst (
                .clk(clk),
                .reset(reset),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate

endmodule

// Modified DFF module with parameterized reset value
module DFF_ResetVal #(parameter RESET_VAL = 1'b0) (
    input clk,
    input reset,
    input d,
    output reg q
);
    always @(negedge clk) begin
        if (reset)
            q <= RESET_VAL;
        else
            q <= d;
    end
endmodule