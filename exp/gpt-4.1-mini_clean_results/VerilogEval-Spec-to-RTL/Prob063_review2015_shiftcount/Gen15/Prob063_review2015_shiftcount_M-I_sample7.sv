module TopModule(
    input        clk,
    input        shift_ena,
    input        count_ena,
    input        data,
    output reg [3:0] q
);

    wire ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (ena) begin
            case ({shift_ena, count_ena})
                2'b10: q <= {data, q[3:1]};  // Shift right, insert data at MSB
                2'b01: q <= q - 1;            // Decrement by 1 modulo 16
                default: q <= q;              // If both high or both low, hold (don't care case)
            endcase
        end
        // else no change, hold value (clock gated effectively)
    end

endmodule