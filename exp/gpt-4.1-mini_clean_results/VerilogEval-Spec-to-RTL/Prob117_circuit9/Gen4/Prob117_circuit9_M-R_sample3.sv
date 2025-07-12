module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

// Combinational next state logic
always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        // Define modulo-7 counting sequence: 4->5->6->0->1->2->3->4
        case (q)
            3'd4: next_q = 3'd5;
            3'd5: next_q = 3'd6;
            3'd6: next_q = 3'd0;
            3'd0: next_q = 3'd1;
            3'd1: next_q = 3'd2;
            3'd2: next_q = 3'd3;
            3'd3: next_q = 3'd4;
            default: next_q = 3'd4; // recover invalid state
        endcase
    end
end

// Sequential update of q
always @(posedge clk) begin
    q <= next_q;
end

endmodule