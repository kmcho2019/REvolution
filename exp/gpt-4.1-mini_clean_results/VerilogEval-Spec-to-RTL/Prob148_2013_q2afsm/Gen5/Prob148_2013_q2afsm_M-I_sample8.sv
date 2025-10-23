module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001,
               B = 4'b0010,
               C = 4'b0100,
               D = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] r_sync;

    // Register inputs to reduce glitches and improve timing
    always @(posedge clk) begin
        if (~resetn)
            r_sync <= 3'b000;
        else
            r_sync <= r;
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic using one-hot encoding
    always @(*) begin
        next_state = 4'b0000;  // default to zero (should not happen)
        case (1'b1)
            state[A]: begin
                if (r_sync[0])       next_state = B;
                else if (r_sync[1])  next_state = C;
                else if (r_sync[2])  next_state = D;
                else                 next_state = A;
            end
            state[B]: next_state = r_sync[0] ? B : A;
            state[C]: next_state = r_sync[1] ? C : A;
            state[D]: next_state = r_sync[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic derived from one-hot state encoding via continuous assignment
    assign g = {state[D], state[C], state[B]};

endmodule