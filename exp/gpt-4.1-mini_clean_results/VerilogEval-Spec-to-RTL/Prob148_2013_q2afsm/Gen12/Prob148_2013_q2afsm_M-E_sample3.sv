module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// One-hot state encoding
localparam A = 4'b0001,
           B = 4'b0010,
           C = 4'b0100,
           D = 4'b1000;

reg [3:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic with priority encoding on requests
always @(*) begin
    case(state)
        A: begin
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        B: next_state = r[0] ? B : A;
        C: next_state = r[1] ? C : A;
        D: next_state = r[2] ? D : A;
        default: next_state = A;
    endcase
end

// Output logic derived directly from one-hot state
always @(*) begin
    case(state)
        B: g = 3'b001;
        C: g = 3'b010;
        D: g = 3'b100;
        default: g = 3'b000;
    endcase
end

endmodule