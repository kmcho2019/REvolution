module TopModule (
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output reg [63:0] q
);

    // Precompute all shifted values from current q

    // Left shift by 1: shift bits left by 1, fill LSB with 0
    wire [63:0] left1 = {q[62:0], 1'b0};
    // Left shift by 8: shift bits left by 8, fill lower 8 bits with 0
    wire [63:0] left8 = {q[55:0], 8'd0};

    // Arithmetic right shift by 1: shift bits right by 1, fill MSB with sign bit q[63]
    wire [63:0] right1 = {q[63], q[63:1]};
    // Arithmetic right shift by 8: shift bits right by 8, fill upper 8 bits with sign bit q[63]
    wire [63:0] right8 = {{8{q[63]}}, q[63:8]};

    // 4-to-1 mux controlled by amount:
    // amount encoding:
    // 2'b00: left shift by 1
    // 2'b01: left shift by 8
    // 2'b10: arithmetic right shift by 1
    // 2'b11: arithmetic right shift by 8

    wire [63:0] shifted;
    always @(*) begin
        case (amount)
            2'b00: shifted = left1;
            2'b01: shifted = left8;
            2'b10: shifted = right1;
            2'b11: shifted = right8;
            default: shifted = q; // default hold (should never happen)
        endcase
    end

    // Sequential logic: synchronous load or shift on ena
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= shifted;
        end
        // else hold q
    end

endmodule