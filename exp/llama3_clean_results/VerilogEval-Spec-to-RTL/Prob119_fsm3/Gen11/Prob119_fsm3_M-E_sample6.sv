module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as 2-bit values
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] state;

// ROM (LUT) to store next states and outputs
reg [1:0] next_state;
reg out_reg;

always @(*) begin
    case ({state, in})
        {A, 1'b0}: begin next_state = A; out_reg = 1'b0; end
        {A, 1'b1}: begin next_state = B; out_reg = 1'b0; end
        {B, 1'b0}: begin next_state = C; out_reg = 1'b0; end
        {B, 1'b1}: begin next_state = B; out_reg = 1'b0; end
        {C, 1'b0}: begin next_state = A; out_reg = 1'b0; end
        {C, 1'b1}: begin next_state = D; out_reg = 1'b0; end
        {D, 1'b0}: begin next_state = C; out_reg = 1'b1; end
        {D, 1'b1}: begin next_state = B; out_reg = 1'b1; end
        default: begin next_state = A; out_reg = 1'b0; end
    endcase
end

// Sequential logic for state transition
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        state <= next_state;
        out <= out_reg;
    end
end

endmodule