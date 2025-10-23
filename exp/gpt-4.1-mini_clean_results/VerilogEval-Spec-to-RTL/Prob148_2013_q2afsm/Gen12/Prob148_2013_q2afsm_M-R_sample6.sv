module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output reg  [2:0]  g
);

    // State encoding using localparam for clarity
    localparam A = 2'd0;
    localparam B = 2'd1;
    localparam C = 2'd2;
    localparam D = 2'd3;

    reg [1:0] state, next_state;

    // Synchronous state register with active-low synchronous reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with explicit priority checking
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

            B: next_state = (r[0]) ? B : A;

            C: next_state = (r[1]) ? C : A;

            D: next_state = (r[2]) ? D : A;

            default: next_state = A;
        endcase
    end

    // Output logic in combinational always block
    always @(*) begin
        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000;
        endcase
    end

endmodule