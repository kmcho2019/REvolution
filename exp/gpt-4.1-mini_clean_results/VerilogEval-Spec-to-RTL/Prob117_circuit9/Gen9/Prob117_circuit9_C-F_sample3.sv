module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// Combinational next state logic with arithmetic modulo-7 and power-aware hold
always @(*) begin
    if (a) begin
        // Hold q=4 when a=1; avoid toggling if already 4
        if (q == 3'd4)
            next_q = q;
        else
            next_q = 3'd4;
    end else begin
        // modulo-7 cycle starting at 4: 4->5->6->0->1->2->3->4
        // Arithmetic form: map q to an index in [0..6], increment mod 7, map back
        // Since states are 4,5,6,0,1,2,3, we can translate q to idx as:
        // idx = (q + 3) mod 7; next_idx = (idx+1) mod 7; next_q = (next_idx + 4) mod 7
        // However, to avoid complexity, use a small expression: 
        // next_q = (q == 3'd3) ? 3'd4 : q + 3'd1;
        // But q can be from 0 to 6. When q=6 next is 0.
        // Since cycle is 4->5->6->0->1->2->3->4,
        // Observe that increment mod 7 with start at 4:
        // So the sequence in decimal: 4,5,6,0,1,2,3 then back to 4
        // This is (q + 1) mod 7, but mapping 0-6 states:
        // But 0..6 are valid 3-bit values, so arithmetic modulo 7 is valid

        // Implement modular increment mod 7:
        if (q == 3'd6)
            next_q = 3'd0;
        else
            next_q = q + 3'd1;
    end
end

// Sequential update of q on rising clock edge
always @(posedge clk) begin
    q <= next_q;
end

endmodule