module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// State encoding (binary)
localparam A = 2'b00;
localparam B = 2'b01;
localparam C = 2'b10;
localparam D = 2'b11;

reg [1:0] state, next_state;

// Next state logic and outputs
always @(*) begin
    // Default assignments
    next_state = A;
    g = 3'b000;

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
            // Outputs in A are 0
            g = 3'b000;
        end

        B: begin
            // Grant device 0
            g = 3'b001;
            // Stay in B if r[0]=1 else go to A
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end

        C: begin
            // Grant device 1
            g = 3'b010;
            // Stay in C if r[1]=1 else go to A
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end

        D: begin
            // Grant device 2
            g = 3'b100;
            // Stay in D if r[2]=1 else go to A
            if (r[2])
                next_state = D;
            else
                next_state = A;
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