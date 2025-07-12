module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// State encoding
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// Next state logic and output logic combinational block
always @(*) begin
    // Default assignments
    next_state = state;
    g = 3'b000;

    case (state)
        A: begin
            // Priority: r[0], else r[1], else r[2], else stay A
            if (r[0])      next_state = B;
            else if (r[1]) next_state = C;
            else if (r[2]) next_state = D;
            else           next_state = A;
            // No grants in A
        end
        B: begin
            g = 3'b001; // grant device 0
            if (r[0])    next_state = B;
            else         next_state = A;
        end
        C: begin
            g = 3'b010; // grant device 1
            if (r[1])    next_state = C;
            else         next_state = A;
        end
        D: begin
            g = 3'b100; // grant device 2
            if (r[2])    next_state = D;
            else         next_state = A;
        end
        default: begin
            next_state = A;
            g = 3'b000;
        end
    endcase
end

// State register with synchronous active-low reset
always @(posedge clk) begin
    if (!resetn)
        state <= A;
    else
        state <= next_state;
end

endmodule