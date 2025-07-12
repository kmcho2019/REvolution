module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] padded_q = {1'b0, q, 1'b0};

    wire [511:0] next_q;

    genvar i;
    generate
        for (i = 0; i < 512; i = i + 1) begin : gen_rule110_logic
            wire left   = padded_q[i + 2];
            wire center = padded_q[i + 1];
            wire right  = padded_q[i];
            // Rule 110 logic:
            // next = (left & center & ~right) == 0
            // According to the truth table, next state can be implemented as:
            // next = ( (left & center & ~right) == 0 ) & (left | center | right) pattern
            // More simply:
            // next = (left & center & ~right) ? 0 : 
            //        (~left & center) | (left & ~center) | (~center & right);
            assign next_q[i] = (left & center & ~right) ? 1'b0 :
                               ((~left) & center) | (left & (~center)) | ((~center) & right);
        end
    endgenerate

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule