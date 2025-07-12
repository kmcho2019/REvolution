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

    // Synchronous active-low reset and state register
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state combinational logic with priority encoding of requests
    always @(*) begin
        case (1'b1)
            state[A]: begin
                if (r[0])      next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else           next_state = A;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
            default:  next_state = A;
        endcase
    end

    // Output logic driven directly by one-hot state bits
    always @(*) begin
        g = 3'b000;
        if (state[B]) g = 3'b001;
        else if (state[C]) g = 3'b010;
        else if (state[D]) g = 3'b100;
    end

endmodule