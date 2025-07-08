module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output reg  [2:0]  g
);

// State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// State flip-flops with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

// State table
always @(*) begin
    case (state)
        A: begin
            // Priority: r[0], then r[1], then r[2]
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
            // Stay in B if r[0] asserted, else back to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Stay in C if r[1] asserted, else back to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Stay in D if r[2] asserted, else back to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: next_state = A;
    endcase
end

// Output logic: grant signals
always @(*) begin
    case (state)
        B: g = 3'b001; // grant device 0
        C: g = 3'b010; // grant device 1
        default: g = 3'b000; // no grant
    endcase
end

endmodule