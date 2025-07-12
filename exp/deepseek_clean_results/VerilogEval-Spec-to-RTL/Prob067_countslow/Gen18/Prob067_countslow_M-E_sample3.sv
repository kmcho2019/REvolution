module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// Combinational next state logic
wire [3:0] next_q;
always @(*) begin
    case (q)
        4'b0000: next_q = 4'b0001; // 0 -> 1
        4'b0001: next_q = 4'b0010; // 1 -> 2
        4'b0010: next_q = 4'b0011; // 2 -> 3
        4'b0011: next_q = 4'b0100; // 3 -> 4
        4'b0100: next_q = 4'b0101; // 4 -> 5
        4'b0101: next_q = 4'b0110; // 5 -> 6
        4'b0110: next_q = 4'b0111; // 6 -> 7
        4'b0111: next_q = 4'b1000; // 7 -> 8
        4'b1000: next_q = 4'b1001; // 8 -> 9
        4'b1001: next_q = 4'b0000; // 9 -> 0
        default: next_q = 4'b0000; // Handle undefined states
    endcase
end

// Sequential state update with enable
always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0000;
    end else if (slowena) begin
        q <= next_q;
    end
    // q maintains value when slowena is low
end

endmodule