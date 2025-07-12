module TopModule (
    input         clk,
    input         load,
    input         ena,
    input  [1:0]  amount,
    input  [63:0] data,
    output reg [63:0] q
);

    reg [63:0] shifted;

    always @* begin
        if (!ena) begin
            shifted = q; // Hold current value when not enabled
        end else begin
            case (amount)
                2'b00: // shift left by 1
                    shifted = {q[62:0], 1'b0};
                2'b01: // shift left by 8
                    shifted = {q[55:0], 8'b0};
                2'b10: // arithmetic shift right by 1
                    shifted = {q[63], q[63:1]};
                2'b11: // arithmetic shift right by 8
                    shifted = {{8{q[63]}}, q[63:8]};
                default:
                    shifted = q; // default hold (shouldn't happen)
            endcase
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= shifted;
    end

endmodule