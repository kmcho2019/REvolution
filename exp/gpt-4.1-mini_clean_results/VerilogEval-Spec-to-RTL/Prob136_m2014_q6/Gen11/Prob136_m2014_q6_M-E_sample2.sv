module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: begin
                if (w)
                    next_state = A;
                else
                    next_state = B;
                z = 1'b0;
            end
            B: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 1'b0;
            end
            C: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 1'b0;
            end
            D: begin
                if (w)
                    next_state = A;
                else
                    next_state = F;
                z = 1'b0;
            end
            E: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                z = 1'b1;
            end
            F: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state register with asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule