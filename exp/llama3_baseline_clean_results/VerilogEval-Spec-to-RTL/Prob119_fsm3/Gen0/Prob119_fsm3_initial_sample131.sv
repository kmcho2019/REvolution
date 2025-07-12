module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// Declare the current state and output
reg [1:0] current_state;
reg [1:0] next_state;
reg out_reg;

// Assign the output
always @(current_state) begin
    case (current_state)
        A: out_reg = 1'b0;
        B: out_reg = 1'b0;
        C: out_reg = 1'b0;
        D: out_reg = 1'b1;
        default: out_reg = 1'b0;
    endcase
end

// Determine the next state
always @(current_state, in) begin
    case (current_state)
        A: if (~in) next_state = A; else next_state = B;
        B: if (~in) next_state = C; else next_state = B;
        C: if (~in) next_state = A; else next_state = D;
        D: if (~in) next_state = C; else next_state = B;
        default: next_state = A;
    endcase
end

// Update the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output assignment
assign out = out_reg;

endmodule