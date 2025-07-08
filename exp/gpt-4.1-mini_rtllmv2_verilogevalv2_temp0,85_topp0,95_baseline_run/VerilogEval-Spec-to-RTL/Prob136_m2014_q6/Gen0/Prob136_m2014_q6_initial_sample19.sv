module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0,
        B = 3'd1,
        C = 3'd2,
        D = 3'd3,
        E = 3'd4,
        F = 3'd5
    } state_t;

    reg [2:0] state, next_state;

    // Next state and output logic
    always @(*) begin
        // Default values
        next_state = state;
        z = 1'b0;

        case (state)
            A: begin
                z = 1'b0;
                if (w == 1'b0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                z = 1'b0;
                if (w == 1'b0)
                    next_state = C;
                else
                    next_state = D;
            end
            C: begin
                z = 1'b0;
                if (w == 1'b0)
                    next_state = E;
                else
                    next_state = D;
            end
            D: begin
                z = 1'b0;
                if (w == 1'b0)
                    next_state = F;
                else
                    next_state = A;
            end
            E: begin
                if (w == 1'b1) begin
                    next_state = D;
                    z = 1'b1;
                end else begin
                    next_state = E;
                    z = 1'b0;
                end
            end
            F: begin
                if (w == 1'b1) begin
                    next_state = D;
                    z = 1'b1;
                end else begin
                    next_state = C;
                    z = 1'b0;
                end
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // State update on clock edge
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule