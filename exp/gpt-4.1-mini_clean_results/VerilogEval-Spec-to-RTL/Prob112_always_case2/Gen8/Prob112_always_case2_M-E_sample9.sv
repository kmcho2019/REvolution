module TopModule (
    input  [3:0] in,
    output reg [1:0] pos
);
    wire [3:0] priority_mask;
    wire [3:0] masked_in;

    // Generate a mask that for each bit indicates if any higher priority bit is set.
    // Higher priority means higher index bit.
    assign priority_mask[3] = 1'b0;               // highest bit has no higher bits
    assign priority_mask[2] = in[3];
    assign priority_mask[1] = in[3] | in[2];
    assign priority_mask[0] = in[3] | in[2] | in[1];

    // Mask input bits with ~priority_mask to isolate only the highest priority set bit
    assign masked_in = in & (~priority_mask);

    always @(*) begin
        case (masked_in)
            4'b0001: pos = 2'd0;
            4'b0010: pos = 2'd1;
            4'b0100: pos = 2'd2;
            4'b1000: pos = 2'd3;
            default: pos = 2'd0; // no bit set
        endcase
    end
endmodule