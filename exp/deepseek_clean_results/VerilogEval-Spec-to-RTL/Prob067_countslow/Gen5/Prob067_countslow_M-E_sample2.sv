module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

// One-hot state encoding (10 states for 0-9)
reg [9:0] state;

always @(posedge clk) begin
    if (reset) begin
        state <= 10'b0000000001; // State 0
    end
    else if (slowena) begin
        case (state)
            10'b0000000001: state <= 10'b0000000010; // 0->1
            10'b0000000010: state <= 10'b0000000100; // 1->2
            10'b0000000100: state <= 10'b0000001000; // 2->3
            10'b0000001000: state <= 10'b0000010000; // 3->4
            10'b0000010000: state <= 10'b0000100000; // 4->5
            10'b0000100000: state <= 10'b0001000000; // 5->6
            10'b0001000000: state <= 10'b0010000000; // 6->7
            10'b0010000000: state <= 10'b0100000000; // 7->8
            10'b0100000000: state <= 10'b1000000000; // 8->9
            10'b1000000000: state <= 10'b0000000001; // 9->0
            default: state <= 10'b0000000001;
        endcase
    end
end

// Convert one-hot state to binary output
always @(*) begin
    case (state)
        10'b0000000001: q = 4'b0000;
        10'b0000000010: q = 4'b0001;
        10'b0000000100: q = 4'b0010;
        10'b0000001000: q = 4'b0011;
        10'b0000010000: q = 4'b0100;
        10'b0000100000: q = 4'b0101;
        10'b0001000000: q = 4'b0110;
        10'b0010000000: q = 4'b0111;
        10'b0100000000: q = 4'b1000;
        10'b1000000000: q = 4'b1001;
        default: q = 4'b0000;
    endcase
end

endmodule