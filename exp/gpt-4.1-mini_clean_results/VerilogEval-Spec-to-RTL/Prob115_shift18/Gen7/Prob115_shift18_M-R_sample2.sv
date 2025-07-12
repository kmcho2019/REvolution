module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    reg [63:0] next_q;

    always @(*) begin
        // Default: hold current value
        next_q = q;

        if (load) begin
            next_q = data;
        end else if (ena) begin
            case (amount)
                2'b00: next_q = q << 1;                  // Shift left by 1
                2'b01: next_q = q << 8;                  // Shift left by 8
                2'b10: begin                             // Arithmetic shift right by 1
                    // Sign extend q to 65 bits for safe arithmetic right shift
                    next_q = $signed({q[63], q}) >>> 1;
                end
                2'b11: begin                             // Arithmetic shift right by 8
                    next_q = $signed({q[63], q}) >>> 8;
                end
                default: next_q = q;
            endcase
        end
        // else no change
    end

    always @(posedge clk) begin
        q <= next_q;
    end

endmodule