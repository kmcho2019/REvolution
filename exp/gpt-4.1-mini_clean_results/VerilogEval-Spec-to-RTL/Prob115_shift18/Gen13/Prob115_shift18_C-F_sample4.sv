module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg  [63:0] shifted_val;

    // Combinational shift calculation: only compute the selected shift variant
    always @* begin
        case (amount)
            2'b00: // shift left by 1
                shifted_val = {q[62:0], 1'b0};
            2'b01: // shift left by 8
                shifted_val = {q[55:0], 8'b0};
            2'b10: // arithmetic shift right by 1
                shifted_val = {msb, q[63:1]};
            2'b11: // arithmetic shift right by 8
                shifted_val = {{8{msb}}, q[63:8]};
            default:
                shifted_val = q; // should not occur
        endcase
    end

    // Sequential logic: synchronous load or shift on ena
    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted_val;
        // else retain q
    end

endmodule