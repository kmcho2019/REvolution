module TopModule(
    input  clk,
    input  areset,
    input  in,
    output reg out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state;

// Next state combinational logic using assign
wire [1:0] next_state;

assign next_state =
    (state == A) ? (in ? B : A) :
    (state == B) ? (in ? B : C) :
    (state == C) ? (in ? D : A) :
    (state == D) ? (in ? B : C) : A;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Output logic (Moore) as combinational always block
always @(*) begin
    case (state)
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule