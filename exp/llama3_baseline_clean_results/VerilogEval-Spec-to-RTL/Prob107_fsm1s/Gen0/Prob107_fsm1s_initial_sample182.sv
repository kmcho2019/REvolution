module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state; // 1-bit state variable
reg [0:0] next_state; // 1-bit next state variable

// State encoding
parameter A = 1'b0;
parameter B = 1'b1;

always @(*) begin
    case (state)
        A: next_state = in ? A : B;
        B: next_state = in ? B : A;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        A: out = 1'b0;
        B: out = 1'b1;
    endcase
end

endmodule