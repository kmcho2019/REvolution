module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] state;
reg clk_en;

// Clock gating control
always @(*) begin
    clk_en = ~a;  // Enable clock only when we need to update state (a=0)
end

// State update with gated clock
always @(posedge clk) begin
    if (clk_en) begin
        case (state)
            3'd4: state <= 3'd5;
            3'd5: state <= 3'd6;
            3'd6: state <= 3'd0;
            default: state <= state + 3'd1;
        endcase
    end
end

// Initialize state
initial begin
    state = 3'd4;
    q = 3'd4;
end

// Output assignment with hold when a=1
always @(*) begin
    q = a ? 3'd4 : state;
end

endmodule