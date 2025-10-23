module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Hold q=4 when a=1
    end else begin
        // Explicit modulo-7 counting sequence from 4: 4->5->6->0->1->2->3->4...
        case (q)
            3'd4: q <= 3'd5;
            3'd5: q <= 3'd6;
            3'd6: q <= 3'd0;
            3'd0: q <= 3'd1;
            3'd1: q <= 3'd2;
            3'd2: q <= 3'd3;
            3'd3: q <= 3'd4;
            default: q <= 3'd4; // recover to 4 if q unknown or invalid
        endcase
    end
end

endmodule