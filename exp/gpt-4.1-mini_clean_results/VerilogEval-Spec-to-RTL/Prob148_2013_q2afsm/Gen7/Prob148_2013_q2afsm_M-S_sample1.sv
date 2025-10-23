module TopModule (
    input        clk,
    input        resetn,
    input  [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            A: begin
                // Priority: r0 > r1 > r2, if none stay in A
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
                // Stay in B if r0=1, else back to A
                next_state = r[0] ? B : A;
            end
            C: begin
                // Stay in C if r1=1, else back to A
                next_state = r[1] ? C : A;
            end
            D: begin
                // D transitions directly back to A since no explicit hold specified
                // But problem states grant continues if request is held. Since D not described explicitly for holds, assume D behaves similarly:
                next_state = r[2] ? D : A;
            end
            default: next_state = A;
        endcase
    end

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Output logic based on state
    always @(*) begin
        g = 3'b000;
        case (state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000;
        endcase
    end

endmodule