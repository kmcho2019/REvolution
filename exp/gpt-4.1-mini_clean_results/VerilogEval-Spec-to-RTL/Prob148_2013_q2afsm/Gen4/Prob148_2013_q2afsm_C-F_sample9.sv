module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // One-hot encoded states
    localparam [3:0]
        A = 4'b0001,
        B = 4'b0010,
        C = 4'b0100,
        D = 4'b1000;

    reg [3:0] state, next_state;

    // State register with synchronous active low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic: priority-based arbitration and simple hold/release logic
    always @(*) begin
        case (state)
            A: begin
                if      (r[0]) next_state = B;  // Highest priority: device 0
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
                else           next_state = A;
            end
            B: next_state = r[0] ? B : A;     // Hold B while r0=1, else back to A
            C: next_state = r[1] ? C : A;     // Hold C while r1=1, else back to A
            D: next_state = r[2] ? D : A;     // Hold D while r2=1, else back to A
            default: next_state = A;
        endcase
    end

    // Output logic registered from state - grants aligned with states B, C, D
    always @(posedge clk) begin
        case (next_state)
            B: g <= 3'b001; // grant device 0
            C: g <= 3'b010; // grant device 1
            D: g <= 3'b100; // grant device 2
            default: g <= 3'b000; // no grant
        endcase
    end

endmodule