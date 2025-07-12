module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

// Binary encoding for states
localparam [1:0]
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11;

reg [1:0] state, next_state;

// Next state and output logic combined
always @(*) begin
    // Default assignments
    next_state = state;
    g = 3'b000;

    case (state)
        A: begin
            // Grant none in A
            g = 3'b000;
            // Priority encoding for requests
            if (r[0])      next_state = B;
            else if (r[1]) next_state = C;
            else if (r[2]) next_state = D;
            else           next_state = A;
        end
        B: begin
            g = 3'b001;  // Grant device 0
            // Remain in B if request from device 0 persists
            if (r[0])
                next_state = B;
            else
                next_state = A;
        end
        C: begin
            g = 3'b010;  // Grant device 1
            if (r[1])
                next_state = C;
            else
                next_state = A;
        end
        D: begin
            g = 3'b100;  // Grant device 2
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