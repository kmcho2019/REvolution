module TopModule(
    input          clk,
    input          shift_ena,
    input          count_ena,
    input          data,
    output reg [3:0] q
);

    wire update_ena = shift_ena | count_ena;

    always @(posedge clk) begin
        if (update_ena) begin
            case ({shift_ena, count_ena})
                2'b10: q <= {data, q[3:1]};  // Shift right, data into MSB (MSB first)
                2'b01: q <= q - 1;            // Decrement by 1 modulo 16
                default: q <= q;              // Should not occur due to assumptions
            endcase
        end
        // else hold current value, no toggling
    end

endmodule