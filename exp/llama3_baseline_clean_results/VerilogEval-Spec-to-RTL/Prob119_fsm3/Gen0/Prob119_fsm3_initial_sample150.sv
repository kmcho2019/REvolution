module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define states
parameter A = 2'd0,
          B = 2'd1,
          C = 2'd2,
          D = 2'd3;

reg [1:0] current_state, next_state;

// State transition logic
always @(*) begin
    case(current_state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A; // Default state
    endcase
end

// Output logic
always @(*) begin
    case(current_state)
        A, B, C: out = 1'd0;
        D: out = 1'd1;
        default: out = 1'd0; // Default output
    endcase
end

// State update with asynchronous reset
always @(posedge clk or posedge areset) begin
    if(areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule