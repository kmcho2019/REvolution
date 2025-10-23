module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// State encoding (2-bit encoding for clarity)
localparam OFF = 2'b00;
localparam ON  = 2'b01;

reg [1:0] state;
wire [1:0] next_state;
wire out_wire;

// Next state logic as combinational assignments
assign next_state = (state == OFF) ? (j ? ON : OFF) :
                    (state == ON)  ? (k ? OFF : ON) :
                    OFF; // default

// Output logic combinational (Moore)
assign out_wire = (state == ON) ? 1'b1 : 1'b0;

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= OFF;
    else
        state <= next_state;
end

// Output assigned from wire
assign out = out_wire;

endmodule