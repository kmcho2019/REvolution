module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Define reset value bits (0x34 = 8'b00110100)
localparam [7:0] RESET_VAL = 8'b00110100;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        // Instantiate one DFF per bit
        dff_neg dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i]),
            .reset_val(RESET_VAL[i])
        );
    end
endgenerate

endmodule

// Custom DFF module with negative edge trigger and sync reset
module dff_neg (
    input clk,
    input reset,
    input d,
    output reg q,
    input reset_val
);
    always @(negedge clk) begin
        if (reset) begin
            q <= reset_val;
        end else begin
            q <= d;
        end
    end
endmodule