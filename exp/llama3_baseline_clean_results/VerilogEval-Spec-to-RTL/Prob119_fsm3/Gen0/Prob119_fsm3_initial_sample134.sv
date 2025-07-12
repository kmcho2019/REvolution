module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define states
reg [1:0] state; // 2 bits can represent 4 states
reg [1:0] next_state;
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case(state)
        A: begin
            if (!in) next_state = A;
            else next_state = B;
        end
        B: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        C: begin
            if (!in) next_state = A;
            else next_state = D;
        end
        D: begin
            if (!in) next_state = C;
            else next_state = B;
        end
        default: next_state = A; // default to state A if state is unknown
    endcase
end

// Output logic
assign out = (state == D) ? 1'b1 : 1'b0;

endmodule