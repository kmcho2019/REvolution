module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire sign_bit = q[63];
    reg  [63:0] shifted;

    always @(*) begin
        case(amount)
            2'b00: begin
                // shift left by 1
                shifted = (q << 1);
            end
            2'b01: begin
                // shift left by 8
                shifted = (q << 8);
            end
            2'b10: begin
                // arithmetic shift right by 1
                shifted = {sign_bit, q[63:1]};
            end
            2'b11: begin
                // arithmetic shift right by 8
                shifted = {{8{sign_bit}}, q[63:8]};
            end
            default: shifted = q; // shouldn't happen
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
    end

endmodule