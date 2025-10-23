module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

wire feedback;
reg [9:0] next_q;

// LFSR feedback polynomial for 10 bits (x^10 + x^7 + 1)
assign feedback = q[9] ^ q[6];

always @(*) begin
    if (reset) begin
        next_q = 10'd0;
    end
    else if (q == 10'd999) begin
        next_q = 10'd0;
    end
    else begin
        // Standard LFSR operation
        next_q = {q[8:0], feedback};
        
        // Correction logic to ensure sequential counting
        if (next_q > 10'd999) begin
            next_q = q + 1'b1;
        end
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule