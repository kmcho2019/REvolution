module TopModule (
    input             clk,
    input             load,
    input             ena,
    input      [1:0]  amount,
    input      [63:0] data,
    output reg [63:0] q
);

    // Intermediate signals for combinational shifting inside the always block
    reg [63:0] shift8_stage;
    reg [63:0] shift1_stage;
    wire msb = q[63];

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // 8-bit shift stage
            case (amount)
                2'b00, 2'b10: shift8_stage <= q;                      // no 8-bit shift
                2'b01:         shift8_stage <= {q[55:0], 8'b0};       // shift left by 8 bits
                2'b11:         shift8_stage <= {{8{msb}}, q[63:8]};   // arithmetic shift right by 8 bits
                default:       shift8_stage <= q;
            endcase

            // 1-bit shift stage based on amount and shifted result from 8-bit stage
            case (amount)
                2'b00:         shift1_stage <= {shift8_stage[62:0], 1'b0};          // shift left by 1 bit
                2'b01:         shift1_stage <= shift8_stage;                        // already shifted 8 bits
                2'b10:         shift1_stage <= {shift8_stage[63], shift8_stage[63:1]}; // arithmetic shift right by 1 bit
                2'b11:         shift1_stage <= shift8_stage;                        // already shifted 8 bits
                default:       shift1_stage <= shift8_stage;
            endcase

            q <= shift1_stage;
        end
        // else hold q
    end

endmodule