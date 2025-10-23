module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// State encoding (binary)
localparam A = 2'b00;
localparam B = 2'b01; // grant device 0
localparam C = 2'b10; // grant device 1
localparam D = 2'b11; // grant device 2

reg [1:0] state, next_state;

// Next state and output combinational logic
always @(*) begin
    // Default outputs and next state
    g = 3'b000;
    next_state = A;

    case(state)
        A: begin
            // Grant based on priority of requests
            if (r[0])
                next_state = B;
            else if (r[1])
                next_state = C;
            else if (r[2])
                next_state = D;
            else
                next_state = A;

            // Outputs in A are all zero (no grant)
            g = 3'b000;
        end
        B: begin
            // Grant device 0 as long as r[0] remains high
            g = 3'b001;
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            // Grant device 1 as long as r[1] remains high
            g = 3'b010;
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            // Grant device 2 as long as r[2] remains high
            g = 3'b100;
            if (r[2])
                next_state = D;
            else
                next_state = A;
        end
        default: begin
            // Default to A for safety
            g = 3'b000;
            next_state = A;
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