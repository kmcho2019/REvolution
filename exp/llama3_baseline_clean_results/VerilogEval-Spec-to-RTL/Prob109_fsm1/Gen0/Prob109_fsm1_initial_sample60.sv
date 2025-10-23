module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] current_state; // 1-bit state variable
reg [0:0] next_state;   // 1-bit next state variable

// Define the encoding
parameter A = 1'b0;
parameter B = 1'b1;

// Output logic
assign out = (current_state == B) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case (current_state)
        A: next_state = (in == 1'b0) ? B : A;
        B: next_state = (in == 1'b0) ? A : B;
        default: next_state = B;
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= B;
    end else begin
        current_state <= next_state;
    end
end

endmodule