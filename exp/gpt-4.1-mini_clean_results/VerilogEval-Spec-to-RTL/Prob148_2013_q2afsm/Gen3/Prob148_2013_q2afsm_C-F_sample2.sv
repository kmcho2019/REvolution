module TopModule (
    input  wire        clk,
    input  wire        resetn,
    input  wire [2:0]  r,
    output wire [2:0]  g
);

    // State encoding (binary)
    localparam [1:0] A = 2'd0,
                     B = 2'd1,
                     C = 2'd2,
                     D = 2'd3;

    reg [1:0] state, next_state;

    // Sequential logic: state register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational logic: next state logic implementing priority and grants
    always @(*) begin
        case (state)
            A: begin
                // Priority encoding of requests
                if      (r[0]) next_state = B; // grant device 0 if requested
                else if (r[1]) next_state = C; // else grant device 1 if requested
                else if (r[2]) next_state = D; // else grant device 2 if requested
                else           next_state = A; // else remain in idle
            end
            B: next_state = r[0] ? B : A;      // stay in B if request still asserted, else back to A
            C: next_state = r[1] ? C : A;      // same for C
            D: next_state = r[2] ? D : A;      // same for D
            default: next_state = A;            // safe default state
        endcase
    end

    // Output logic: grant lines decoded directly from state
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule