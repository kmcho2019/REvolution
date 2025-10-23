module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A = 2'b00; // Idle
    localparam B = 2'b01; // Grant device 0
    localparam C = 2'b10; // Grant device 1
    localparam D = 2'b11; // Grant device 2

    reg [1:0] state, next_state;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            A: begin
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
                next_state = r[0] ? B : A;
            end

            C: begin
                next_state = r[1] ? C : A;
            end

            D: begin
                next_state = r[2] ? D : A;
            end

            default: next_state = A;
        endcase
    end

    // Output logic based on state
    always @(*) begin
        case(state)
            A: g = 3'b000;
            B: g = 3'b001;
            C: g = 3'b010;
            D: g = 3'b100;
            default: g = 3'b000;
        endcase
    end

endmodule