module TopModule (
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // State encoding (3-bit binary)
    localparam [2:0]
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5;

    reg [2:0] state, next_state;

    // Next state and output logic (combinational)
    always @(*) begin
        case (state)
            A: begin
                if (w)
                    next_state = B;
                else
                    next_state = A;
                z = 1'b0;
            end
            B: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
                z = 1'b0;
            end
            C: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
                z = 1'b0;
            end
            D: begin
                if (w)
                    next_state = F;
                else
                    next_state = A;
                z = 1'b0;
            end
            E: begin
                if (w)
                    next_state = E;
                else
                    next_state = D;
                z = 1'b1;
            end
            F: begin
                if (w)
                    next_state = C;
                else
                    next_state = D;
                z = 1'b1;
            end
            default: begin // Default safe state
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // State register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule