module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// One-hot state encoding
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

reg [3:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next state logic: combinational
always @(*) begin
    next_state = state;  // default hold

    case (state)
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
        B: next_state = (r[0]) ? B : A;
        C: next_state = (r[1]) ? C : A;
        D: next_state = (r[2]) ? D : A;
        default: next_state = A;
    endcase
end

// Output logic: grant signals directly from state bits
always @(*) begin
    case (state)
        B: g = 3'b001;
        C: g = 3'b010;
        D: g = 3'b100;
        default: g = 3'b000; // A or invalid states grant nothing
    endcase
end

endmodule