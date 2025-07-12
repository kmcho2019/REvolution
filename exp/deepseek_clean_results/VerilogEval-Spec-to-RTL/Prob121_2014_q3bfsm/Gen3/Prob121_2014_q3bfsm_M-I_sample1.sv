module TopModule (
    input clk,
    input reset,
    input x,
    output reg z
);

    // Gray code state encoding
    reg [2:0] y;  // Present state
    reg [2:0] next_state;

    // State transitions (combinational)
    always @(*) begin
        case (y)
            3'b000: next_state = x ? 3'b001 : 3'b000;  // 000 -> 001/000
            3'b001: next_state = x ? 3'b110 : 3'b001;  // 001 -> 100/001
            3'b011: next_state = x ? 3'b001 : 3'b011;  // 010 -> 001/010
            3'b010: next_state = x ? 3'b011 : 3'b001;  // 011 -> 010/001
            3'b110: next_state = x ? 3'b110 : 3'b010;  // 100 -> 100/011
        endcase
    end

    // State register and output register
    always @(posedge clk) begin
        if (reset) begin
            y <= 3'b000;  // Synchronous reset to state 000
            z <= 1'b0;
        end else begin
            y <= next_state;
            // Registered output reduces glitches
            z <= (next_state == 3'b010 || next_state == 3'b110);
        end
    end

endmodule