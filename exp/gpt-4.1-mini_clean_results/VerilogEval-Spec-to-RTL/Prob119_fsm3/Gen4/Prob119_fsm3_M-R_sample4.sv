module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// State encoding
localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state;
wire [1:0] next_state;
wire out_comb;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Next state combinational logic
assign next_state = (state == A) ? (in ? B : A) :
                    (state == B) ? (in ? B : C) :
                    (state == C) ? (in ? D : A) :
                    (state == D) ? (in ? B : C) :
                    A; // default

// Output combinational logic (Moore)
assign out_comb = (state == D) ? 1'b1 : 1'b0;

assign out = out_comb;

endmodule