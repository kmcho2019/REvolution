module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];
    reg  [63:0] shift_result;

    always @* begin
        case (amount)
            2'b00: // shift left by 1
                shift_result = q << 1;
            2'b01: // shift left by 8
                shift_result = q << 8;
            2'b10: // arithmetic shift right by 1
                shift_result = {msb, q[63:1]};
            2'b11: // arithmetic shift right by 8
                shift_result = {{8{msb}}, q[63:8]};
            default:
                shift_result = q;
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift_result;
        end
    end

endmodule