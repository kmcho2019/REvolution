module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001,
                     B = 4'b0010,
                     C = 4'b0100,
                     D = 4'b1000;

    reg [3:0] current_state, next_state;

    // State register (synchronous reset)
    always @(posedge clk) begin
        if (!resetn)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic - optimized with parallel case
    always @(*) begin
        next_state = A;  // Default
        case (1'b1) // synthesis parallel_case
            current_state[A]: begin
                if (r[0])       next_state = B;
                else if (r[1])   next_state = C;
                else if (r[2])   next_state = D;
            end
            current_state[B]: next_state = r[0] ? B : A;
            current_state[C]: next_state = r[1] ? C : A;
            current_state[D]: next_state = r[2] ? D : A;
        endcase
    end

    // Output logic - combined into single always block
    always @(*) begin
        g = 3'b000;
        case (1'b1) // synthesis parallel_case
            current_state[B]: g[0] = 1'b1;
            current_state[C]: g[1] = 1'b1;
            current_state[D]: g[2] = 1'b1;
        endcase
    end

endmodule