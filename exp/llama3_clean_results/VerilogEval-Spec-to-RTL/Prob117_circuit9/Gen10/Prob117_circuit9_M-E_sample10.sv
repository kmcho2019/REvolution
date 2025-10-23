module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;
reg [2:0] next_state;

always @(*) begin
    case(state)
        3'b100: next_state = (a) ? 3'b100 : 3'b101; // 4
        3'b101: next_state = (a) ? 3'b100 : 3'b110; // 5
        3'b110: next_state = (a) ? 3'b100 : 3'b111; // 6
        3'b111: next_state = (a) ? 3'b100 : 3'b000; // 0 -> 7 (wrap around)
        default: next_state = (a) ? 3'b100 : state + 1;
    endcase
end

always @(posedge clk) begin
    state <= next_state;
    if(a) begin
        q <= 4; // Reset q to 4 when a is high
    end else begin
        case(state)
            3'b100: q <= 4;
            3'b101: q <= 5;
            3'b110: q <= 6;
            3'b111: q <= 0;
            default: q <= state;
        endcase
    end
end

// Initialize the output
initial begin
    state = 3'b100; // Initialize state to 4
    q = 4;
end

endmodule