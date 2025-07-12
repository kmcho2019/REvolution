module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output wire signed [31:0] c
);

    // Split operands into halves
    wire signed [15:0] a_lo = a[15:0];
    wire signed [15:0] a_hi = a[31:16];
    wire signed [15:0] b_lo = b[15:0];
    wire signed [15:0] b_hi = b[31:16];

    // Partial products
    wire signed [31:0] p_ll = a_lo * b_lo;
    wire signed [31:0] p_lh = a_lo * b_hi;
    wire signed [31:0] p_hl = a_hi * b_lo;
    wire signed [31:0] p_hh = a_hi * b_hi;

    // Accumulation registers
    reg signed [31:0] acc_lo;
    reg signed [31:0] acc_hi;
    reg signed [15:0] carry_save;

    // Carry propagation counter
    reg [2:0] carry_prop_cnt;

    // Final output
    assign c = {acc_hi[31:16], acc_lo[31:16]} + 
               {14'b0, carry_save, 2'b0} + 
               {p_hh[29:0], 2'b0};

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc_lo <= 32'd0;
            acc_hi <= 32'd0;
            carry_save <= 16'd0;
            carry_prop_cnt <= 3'd0;
        end else begin
            // Low accumulation (full add)
            acc_lo <= acc_lo + p_ll + {p_lh[15:0], 16'b0} + {p_hl[15:0], 16'b0};

            // High accumulation (carry-save)
            {carry_save, acc_hi} <= acc_hi + 
                                   {p_lh[31:16], 16'b0} + 
                                   {p_hl[31:16], 16'b0} + 
                                   {carry_save, 16'b0};

            // Conditional carry propagation
            carry_prop_cnt <= carry_prop_cnt + 1;
            if (carry_prop_cnt == 3'd7) begin
                acc_hi <= acc_hi + {14'b0, carry_save, 2'b0};
                carry_save <= 16'd0;
            end
        end
    end

endmodule