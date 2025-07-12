module ring_counter(
    input clk,
    input reset,
    output [7:0] out
);

reg [7:0] state;
reg [7:0] next_state;

// Initialize the state with the LSB set to 1 when reset is high
always @(posedge reset or posedge clk) begin
    if (reset) begin
        state <= 8'b0000_0001;
    end else begin
        state <= next_state;
    end
end

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        8'b0000_0001: next_state = 8'b0000_0010;
        8'b0000_0010: next_state = 8'b0000_0100;
        8'b0000_0100: next_state = 8'b0000_1000;
        8'b0000_1000: next_state = 8'b0001_0000;
        8'b0001_0000: next_state = 8'b0010_0000;
        8'b0010_0000: next_state = 8'b0100_0000;
        8'b0100_0000: next_state = 8'b1000_0000;
        8'b1000_0000: next_state = 8'b0000_0001;
        default: next_state = 8'b0000_0001;
    endcase
end

assign out = state;

endmodule