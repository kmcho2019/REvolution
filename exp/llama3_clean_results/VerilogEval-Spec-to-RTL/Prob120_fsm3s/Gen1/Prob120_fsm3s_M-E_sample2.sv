module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Current state
reg [1:0] current_state;
reg [1:0] next_state;

// State transition logic and output logic
always_comb begin
    case ({current_state, in})
        {A, 1'b0}: begin next_state = A; out = 1'b0; end
        {A, 1'b1}: begin next_state = B; out = 1'b0; end
        {B, 1'b0}: begin next_state = C; out = 1'b0; end
        {B, 1'b1}: begin next_state = B; out = 1'b0; end
        {C, 1'b0}: begin next_state = A; out = 1'b0; end
        {C, 1'b1}: begin next_state = D; out = 1'b0; end
        {D, 1'b0}: begin next_state = C; out = 1'b1; end
        {D, 1'b1}: begin next_state = B; out = 1'b1; end
        default: begin next_state = A; out = 1'bx; end
    endcase
end

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule