module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define states
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

// State register
reg [1:0] current_state;
reg [1:0] next_state;

// State transition logic
always @(current_state, in) begin
    case (current_state)
        A: next_state = (in)? B : A;
        B: next_state = (in)? B : C;
        C: next_state = (in)? D : A;
        D: next_state = (in)? B : C;
        default: next_state = A;
    endcase
end

// Output logic
always @(current_state) begin
    case (current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// Update state register
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule