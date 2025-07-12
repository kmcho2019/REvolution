module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state, next_state;

// State transition combinational logic
always @(*) begin
    case(state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

// State register with synchronous active-high reset
always @(posedge clk) begin
    if(reset)
        state <= A;
    else
        state <= next_state;
end

// Output logic (Moore output)
always @(*) begin
    case(state)
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule