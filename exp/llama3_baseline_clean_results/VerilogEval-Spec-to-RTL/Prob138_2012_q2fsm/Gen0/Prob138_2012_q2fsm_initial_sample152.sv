module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define state codes
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;
parameter F = 4'b0101;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: next_state = (w)? B : A;
        B: next_state = (w)? C : D;
        C: next_state = (w)? E : D;
        D: next_state = (w)? F : A;
        E: next_state = (w)? E : D;
        F: next_state = (w)? C : D;
        default: next_state = A; // Should never happen
    endcase
end

// Output logic
assign z = (current_state == E)? 1'b1 : 1'b0;

endmodule