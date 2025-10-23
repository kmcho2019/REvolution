module TopModule (
    input clk,
    input a,
    input b,
    input [1:0] config_sel,  // New configuration input
    output reg out           // Consolidated output
);

    // Internal signals for each implementation
    wire out_assign;
    reg out_always_comb;
    reg out_always_ff;
    reg out_always_ff_inverted;

    // Continuous assignment implementation
    assign out_assign = a ^ b;

    // Combinational always block implementation
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Positive edge sequential implementation
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

    // Negative edge sequential implementation (bonus)
    always @(negedge clk) begin
        out_always_ff_inverted <= a ^ b;
    end

    // Output multiplexer based on configuration
    always @(*) begin
        case(config_sel)
            2'b00: out = out_assign;
            2'b01: out = out_always_comb;
            2'b10: out = out_always_ff;
            2'b11: out = out_always_ff_inverted;
            default: out = out_assign;
        endcase
    end

endmodule