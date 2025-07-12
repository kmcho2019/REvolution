module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Binary state encoding
    localparam A = 2'b00;  // Idle state
    localparam B = 2'b01;  // Grant to r0
    localparam C = 2'b10;  // Grant to r1
    localparam D = 2'b11;  // Grant to r2
    
    reg [1:0] state, next_state;

    // State register
    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    // Next state logic with explicit priority
    always @(*) begin
        case (state)
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else next_state = A;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Output logic - explicit grant assignments
    always @(*) begin
        g = 3'b000;  // Default no grants
        case (state)
            B: g[0] = 1'b1;
            C: g[1] = 1'b1;
            D: g[2] = 1'b1;
        endcase
    end

endmodule