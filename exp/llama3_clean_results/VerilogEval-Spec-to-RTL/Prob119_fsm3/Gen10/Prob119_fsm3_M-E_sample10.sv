module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit binary values
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// Next state logic using a lookup table (LUT)
always @(state, in) begin
    case ({state, in})
        {A, 1'b0}: state <= A;
        {A, 1'b1}: state <= B;
        {B, 1'b0}: state <= C;
        {B, 1'b1}: state <= B;
        {C, 1'b0}: state <= A;
        {C, 1'b1}: state <= D;
        {D, 1'b0}: state <= C;
        {D, 1'b1}: state <= B;
        default: state <= A;
    endcase
end

// Output logic using a lookup table (LUT)
always @(state) begin
    case (state)
        A: out <= 1'b0;
        B: out <= 1'b0;
        C: out <= 1'b0;
        D: out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        // Do nothing, state is updated by the combinational logic
    end
end

endmodule