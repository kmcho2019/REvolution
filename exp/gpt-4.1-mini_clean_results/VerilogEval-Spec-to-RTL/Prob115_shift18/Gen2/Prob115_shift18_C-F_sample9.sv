module TopModule (
    input        clk,
    input        load,
    input        ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    wire msb = q[63];

    // Stage 1: 8-bit shift (or no shift)
    reg [63:0] shift8;
    always @(*) begin
        case (amount)
            2'b01:    shift8 = q << 8;                   // shift left by 8
            2'b11:    shift8 = {{8{msb}}, q[63:8]};     // arithmetic shift right by 8
            default:  shift8 = q;                        // no 8-bit shift for 00 and 10
        endcase
    end

    // Stage 2: 1-bit shift (or no shift)
    reg [63:0] shift1;
    always @(*) begin
        case (amount)
            2'b00:    shift1 = shift8 << 1;              // shift left by 1
            2'b10:    shift1 = {shift8[63], shift8[63:1]}; // arithmetic shift right by 1
            default:  shift1 = shift8;                    // no 1-bit shift for 01 and 11
        endcase
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shift1;
        end
    end

endmodule