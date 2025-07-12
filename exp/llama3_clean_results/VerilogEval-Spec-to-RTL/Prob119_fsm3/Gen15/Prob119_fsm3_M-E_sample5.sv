module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states as one-hot values
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

// State register
reg [3:0] state;
reg [3:0] next_state;

// Next state logic and sequential logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        case (state)
            A: next_state <= in? B : A;
            B: next_state <= in? B : C;
            C: next_state <= in? D : A;
            D: next_state <= in? B : C;
            default: next_state <= A;
        endcase
        state <= next_state;
    end
end

// Output logic
assign out = (state == D)? 1 : 0;

endmodule