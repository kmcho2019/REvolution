module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output reg  [2:0]  g
);

    // State encoding (binary, 2 bits) with localparam for clarity
    localparam A = 2'b00; // idle (no grants)
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Sequential logic: State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational next-state logic
    always @(*) begin
        case(state)
            A: begin
                if (r[0])
                    next_state = B;        // grant device 0 (highest priority)
                else if (r[1])
                    next_state = C;        // grant device 1
                else if (r[2])
                    next_state = D;        // grant device 2 (lowest priority)
                else
                    next_state = A;        // remain idle
            end

            B: next_state = r[0] ? B : A;    // hold if request persists, else idle
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;

            default: next_state = A;          // safe fallback to idle
        endcase
    end

    // Combinational output logic based on current state
    always @(*) begin
        case (state)
            B: g = 3'b001;  // grant device 0
            C: g = 3'b010;  // grant device 1
            D: g = 3'b100;  // grant device 2
            default: g = 3'b000; // no grant in idle or invalid states
        endcase
    end

endmodule