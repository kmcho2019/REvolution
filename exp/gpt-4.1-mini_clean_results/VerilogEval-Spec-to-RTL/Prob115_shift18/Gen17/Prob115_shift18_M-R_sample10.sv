module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    always @(*) begin
        case (amount)
            2'b00: shifted = {q[62:0], 1'b0};                         // shift left by 1
            2'b01: shifted = {q[55:0], 8'b0};                         // shift left by 8
            2'b10: shifted = {q[63], q[63:1]};                        // arithmetic shift right by 1
            2'b11: shifted = {{8{q[63]}}, q[63:8]};                   // arithmetic shift right by 8
            default: shifted = q;
        endcase
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else if (ena)
            q <= shifted;
        else
            q <= q;
    end

endmodule