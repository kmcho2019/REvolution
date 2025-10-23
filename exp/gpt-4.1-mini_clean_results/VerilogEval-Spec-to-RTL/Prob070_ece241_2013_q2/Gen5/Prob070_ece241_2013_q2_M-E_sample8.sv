module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out_sop,
    output out_pos
);

    wire [3:0] in_val = {a,b,c,d};

    reg sop_val;

    always @(*) begin
        // Default output is 0
        sop_val = 1'b0;
        case(in_val)
            4'd2:  sop_val = 1'b1;  // 0010
            4'd7:  sop_val = 1'b1;  // 0111
            4'd15: sop_val = 1'b1;  // 1111
            // Inputs that never occur (3,8,11,12) are not assigned (don't care)
            // All other specified inputs map to 0 (default)
            default: sop_val = 1'b0;
        endcase
    end

    assign out_sop = sop_val;

    // out_pos is the minimal Product-of-Sums form representing same logic
    // Since out_pos = NOT(out_sop) for inputs that occur,
    // and undefined for don't-care inputs, implement as:
    // out_pos = ~(out_sop) for inputs that are not don't cares
    // For don't cares, assign 1 (logic high) to avoid false zero

    wire dont_care = (in_val == 4'd3) | (in_val == 4'd8) | (in_val == 4'd11) | (in_val == 4'd12);

    assign out_pos = dont_care ? 1'b1 : ~out_sop;

endmodule