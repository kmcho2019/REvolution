module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted_value;
    wire msb = q[63];

    always @(*) begin
        case (amount)
            2'b00: shifted_value = {q[62:0], 1'b0};                    // shift left by 1
            2'b01: shifted_value = {q[55:0], 8'b0};                    // shift left by 8
            2'b10: shifted_value = {msb, q[63:1]};                     // arithmetic shift right by 1
            2'b11: shifted_value = {{8{msb}}, q[63:8]};                // arithmetic shift right by 8
            default: shifted_value = q;                                // default: hold value
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted_value;
    end

endmodule