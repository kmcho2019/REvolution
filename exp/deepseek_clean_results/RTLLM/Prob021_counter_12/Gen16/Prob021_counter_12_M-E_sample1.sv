module counter_12 (
    input wire rst_n,
    input wire clk,
    input wire valid_count,
    output reg [3:0] out
);

// One-hot state encoding (12 states)
reg [11:0] state;

// Next state logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 12'b0000_0000_0001;  // Reset to state0
    end else if (valid_count) begin
        // Rotate the '1' through the states
        state <= {state[10:0], state[11]};
    end
end

// Output encoding (convert one-hot to binary)
always @(*) begin
    case (state)
        12'b0000_0000_0001: out = 4'b0000;
        12'b0000_0000_0010: out = 4'b0001;
        12'b0000_0000_0100: out = 4'b0010;
        12'b0000_0000_1000: out = 4'b0011;
        12'b0000_0001_0000: out = 4'b0100;
        12'b0000_0010_0000: out = 4'b0101;
        12'b0000_0100_0000: out = 4'b0110;
        12'b0000_1000_0000: out = 4'b0111;
        12'b0001_0000_0000: out = 4'b1000;
        12'b0010_0000_0000: out = 4'b1001;
        12'b0100_0000_0000: out = 4'b1010;
        12'b1000_0000_0000: out = 4'b1011;
        default:            out = 4'b0000;
    endcase
end

endmodule