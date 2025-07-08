module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output [2:0] g
);

// State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// Next-state logic
always @(*) begin
    case (state)
        A: begin
            // Priority encoder for requests
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
            // Stay in B if r[0] asserted, else go to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Stay in C if r[1] asserted, else go to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Stay in D if r[2] asserted, else go to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: grant signals g based on state
assign g = (state == B) ? 3'b001 :
           (state == C) ? 3'b010 :
           (state == D) ? 3'b100 :
                          3'b000;

endmodule