module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg [0:0] state
);

reg d;

// Combinational logic to generate the 'd' input for the flip-flop
always @(*) begin
    if (b) begin
        if (!a) begin
            d = ~state; // Toggle the state when b is 1 and a is 0
        end else begin
            d = 0; // Set state to 0 when b is 1 and a is 1
        end
    end else begin
        d = state; // No change when b is 0
    end
end

// D flip-flop
always @ (posedge clk) begin
    state <= d;
end

// Combinational logic to generate the output 'q'
assign q = b ? (!a && !state) || (a && !state) : state;

endmodule