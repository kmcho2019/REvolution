module TopModule (
    input clk,
    input a,
    output [2:0] q
);

reg [2:0] state;
wire gated_clk;
wire [2:0] next_state;

// Clock gating
assign gated_clk = clk & (~a);

// Initialize state
initial state = 3'd4;

// Custom incrementer logic
always @(*) begin
    case (state)
        3'd4: next_state = 3'd5;
        3'd5: next_state = 3'd6;
        3'd6: next_state = 3'd0;
        default: next_state = 3'd1; // handles 0,1,2,3 cases
    endcase
end

// Sequential state update with clock gating
always @(posedge gated_clk) begin
    if (~a) begin
        state <= next_state;
    end
end

// Output remains 4 when a=1, else follows state
assign q = a ? 3'd4 : state;

endmodule