module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-hot state encoding
reg [9:0] state;

// Next state logic
wire [9:0] next_state;
assign next_state = reset ? 10'b0000000001 :  // State 0
                   ~slowena ? state :         // Hold current state
                   state == 10'b0000000001 ? 10'b0000000010 :  // 0->1
                   state == 10'b0000000010 ? 10'b0000000100 :  // 1->2
                   state == 10'b0000000100 ? 10'b0000001000 :  // 2->3
                   state == 10'b0000001000 ? 10'b0000010000 :  // 3->4
                   state == 10'b0000010000 ? 10'b0000100000 :  // 4->5
                   state == 10'b0000100000 ? 10'b0001000000 :  // 5->6
                   state == 10'b0001000000 ? 10'b0010000000 :  // 6->7
                   state == 10'b0010000000 ? 10'b0100000000 :  // 7->8
                   state == 10'b0100000000 ? 10'b1000000000 :  // 8->9
                   10'b0000000001;                              // 9->0

// State register
always @(posedge clk) begin
    state <= next_state;
end

// Output encoding
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0000;  // 0
        10'b0000000010: q = 4'b0001;  // 1
        10'b0000000100: q = 4'b0010;  // 2
        10'b0000001000: q = 4'b0011;  // 3
        10'b0000010000: q = 4'b0100;  // 4
        10'b0000100000: q = 4'b0101;  // 5
        10'b0001000000: q = 4'b0110;  // 6
        10'b0010000000: q = 4'b0111;  // 7
        10'b0100000000: q = 4'b1000;  // 8
        10'b1000000000: q = 4'b1001;  // 9
        default: q = 4'b0000;         // Default to 0
    endcase
end

endmodule