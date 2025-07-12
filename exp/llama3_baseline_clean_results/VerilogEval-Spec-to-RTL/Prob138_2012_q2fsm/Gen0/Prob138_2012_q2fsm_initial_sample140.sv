module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [3:0] state;
reg [3:0] next_state;

// State codes
parameter A = 4'b0001;
parameter B = 4'b0010;
parameter C = 4'b0011;
parameter D = 4'b0100;
parameter E = 4'b0101;
parameter F = 4'b0110;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A;
    endcase
end

// Output z
assign z = (state == E) || (state == F);

endmodule