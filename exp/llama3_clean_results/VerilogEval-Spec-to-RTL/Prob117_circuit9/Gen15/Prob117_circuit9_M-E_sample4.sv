module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

// Define the states for q
reg [2:0] state, next_state;

// State transition logic
always @(*) begin
    if (a) begin
        next_state = 4;
    end else begin
        case (state)
            3'b000: next_state = 4'b001;
            3'b001: next_state = 4'b010;
            3'b010: next_state = 4'b011;
            3'b011: next_state = 4'b100;
            3'b100: next_state = 4'b101;
            3'b101: next_state = 4'b110;
            3'b110: next_state = 4'b000;
            default: next_state = 4'b000;
        endcase
    end
end

// Update the current state at every positive edge of the clock
always @(posedge clk) begin
    state <= next_state;
    q <= state;
end

// Initialize the output
initial begin
    state = 4;
    q = 4;
end

endmodule