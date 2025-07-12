module TopModule (
    input          clk,
    input          load,
    input          ena,
    input   [1:0]  amount,
    input   [63:0] data,
    output reg [63:0] q
);

    // Intermediate wires for shift-by-8 and shift-by-1 results
    reg [63:0] shift8_left;
    reg [63:0] shift8_right;
    reg [63:0] shift1_left;
    reg [63:0] shift1_right;

    // For arithmetic right shift, sign extension bit is q[63]
    wire sign = q[63];

    // Combinational logic for 8-bit left shift (logical)
    always @(*) begin
        shift8_left = {q[55:0], 8'b0};
    end

    // Combinational logic for 8-bit right arithmetic shift
    always @(*) begin
        shift8_right = {{8{sign}}, q[63:8]};
    end

    // Combinational logic for 1-bit left shift (logical)
    always @(*) begin
        shift1_left = {q[62:0], 1'b0};
    end

    // Combinational logic for 1-bit right arithmetic shift
    always @(*) begin
        shift1_right = {sign, q[63:1]};
    end

    reg [63:0] next_shift_stage;
    reg [63:0] next_val;

    always @(*) begin
        // Decode direction and amount
        // amount[1] = direction (0=left, 1=right)
        // amount[0] = shift by 1 if 0, shift by 8 if 1
        if (amount[1] == 1'b0) begin
            // Shift left path
            if (amount[0] == 1'b0)
                next_shift_stage = shift1_left;  // shift left by 1
            else
                next_shift_stage = shift8_left;  // shift left by 8
        end else begin
            // Shift right path (arithmetic)
            if (amount[0] == 1'b0)
                next_shift_stage = shift1_right; // shift right by 1
            else
                next_shift_stage = shift8_right; // shift right by 8
        end

        // Select next value based on load and ena
        if (load)
            next_val = data;
        else if (ena)
            next_val = next_shift_stage;
        else
            next_val = q;
    end

    // Sequential update of the register
    always @(posedge clk) begin
        q <= next_val;
    end

endmodule