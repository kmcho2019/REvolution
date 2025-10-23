module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (binary)
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Sequential logic: state register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            A: begin
                if (r[0])
                    next_state = B;       // grant device 0
                else if (r[1])
                    next_state = C;       // grant device 1
                else if (r[2])
                    next_state = D;       // grant device 2
                else
                    next_state = A;       // remain idle
            end

            B: next_state = r[0] ? B : A; // stay if request persists, else idle
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;

            default: next_state = A;         // safe default
        endcase
    end

    // Output combinational logic based on state
    always @(*) begin
        case (state)
            B: g = 3'b001;
            C: g = 3'b010;
            D: g = 3'b100;
            default: g = 3'b000; // A or illegal states: no grant
        endcase
    end

endmodule