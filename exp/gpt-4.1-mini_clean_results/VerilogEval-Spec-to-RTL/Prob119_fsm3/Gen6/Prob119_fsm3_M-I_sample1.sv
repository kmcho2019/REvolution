module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// State encoding
localparam A = 2'd0;
localparam B = 2'd1;
localparam C = 2'd2;
localparam D = 2'd3;

reg [1:0] state, next_state;
wire state_changing;

// Next state logic combinational
always @(*) begin
    case(state)
        A: next_state = in ? B : A;
        B: next_state = in ? B : C;
        C: next_state = in ? D : A;
        D: next_state = in ? B : C;
        default: next_state = A;
    endcase
end

assign state_changing = (state != next_state);

// State register with asynchronous reset and clock enable
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else if (state_changing)
        state <= next_state;
end

// Moore output
assign out = (state == D);

endmodule