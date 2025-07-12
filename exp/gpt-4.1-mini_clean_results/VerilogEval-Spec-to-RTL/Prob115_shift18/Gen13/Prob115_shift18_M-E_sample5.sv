module TopModule(
    input           clk,
    input           load,
    input           ena,
    input   [1:0]   amount,
    input   [63:0]  data,
    output  reg [63:0] q
);

    // Decode amount:
    // 00: shift left by 1
    // 01: shift left by 8
    // 10: shift right by 1 (arithmetic)
    // 11: shift right by 8 (arithmetic)

    // Extract direction and shift amount
    wire shift_left = (amount[1] == 1'b0);
    wire shift_by_8 = (amount[0] == 1'b1);
    
    // Intermediate signals for staged shifts
    reg [63:0] stage1;
    reg [63:0] stage2;

    always @(*) begin
        // Stage 1: shift by 8 bits or no shift if amount[0] = 0 for 1-bit shifts
        if (shift_left) begin
            if (shift_by_8)
                stage1 = q << 8;
            else
                stage1 = q;          // no 8-bit shift for 1-bit shift amount
        end else begin // shift right arithmetic
            if (shift_by_8)
                stage1 = {{8{q[63]}}, q[63:8]};
            else
                stage1 = q;          // no 8-bit shift for 1-bit shift amount
        end
    end

    always @(*) begin
        // Stage 2: shift by 1 bit or no shift if amount[0] = 1 for 8-bit shifts
        if (shift_left) begin
            if (!shift_by_8)
                stage2 = stage1 << 1;
            else
                stage2 = stage1;     // no 1-bit shift for 8-bit shift amount
        end else begin // shift right arithmetic
            if (!shift_by_8)
                stage2 = {stage1[63], stage1[63:1]};
            else
                stage2 = stage1;     // no 1-bit shift for 8-bit shift amount
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            q <= stage2;
        end
    end

endmodule