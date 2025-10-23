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
reg [1:0] next_state;

// Output register
reg out_reg;

// Next state logic and output logic
always @(*) begin
    case (state)
        A: next_state = in? B : A;
        B: next_state = in? B : C;
        C: next_state = in? D : A;
        D: next_state = in? B : C;
        default: next_state = A;
    endcase
    
    out_reg = (state == D)? 1'b1 : 1'b0;
end

// Sequential logic
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