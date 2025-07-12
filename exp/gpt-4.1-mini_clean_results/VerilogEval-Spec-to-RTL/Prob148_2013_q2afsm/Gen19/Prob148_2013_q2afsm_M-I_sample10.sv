module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// Binary encoding for states (2 bits)
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// Next state logic
always @(*) begin
    case (state)
        A: begin
            // Priority: r[0] > r[1] > r[2]
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        B: begin
            // Stay in B if r[0] still asserted, else back to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Stay in C if r[1] still asserted, else back to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Stay in D if r[2] still asserted, else back to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Output logic based on current state
always @(*) begin
    case (state)
        A: g = 3'b000;
        B: g = 3'b001;
        C: g = 3'b010;
        D: g = 3'b100;
        default: g = 3'b000;
    endcase
end

endmodule