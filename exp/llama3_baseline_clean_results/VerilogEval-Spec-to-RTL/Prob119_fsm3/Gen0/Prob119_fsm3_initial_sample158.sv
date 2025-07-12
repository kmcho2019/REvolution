module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Declare the state register
reg [1:0] state;
reg [1:0] next_state;

// Declare the output
reg out_reg;

// Asynchronous reset and clock edge
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        A: out_reg = 0;
        B: out_reg = 0;
        C: out_reg = 0;
        D: out_reg = 1;
        default: out_reg = 0;
    endcase
end

// Output assignment
assign out = out_reg;

endmodule