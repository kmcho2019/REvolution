module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    // State encoding as parameters
    parameter A = 3'd0;
    parameter B = 3'd1;
    parameter C = 3'd2;
    parameter D = 3'd3;
    parameter E = 3'd4;
    parameter F = 3'd5;

    reg [2:0] state, next_state;

    // State register update (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Next state and output logic combined (combinational)
    always @(*) begin
        case(state)
            A: begin
                if (w == 1'b0) next_state = B;
                else           next_state = A;
                z = 1'b0;
            end
            B: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
                z = 1'b0;
            end
            C: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
                z = 1'b0;
            end
            D: begin
                if (w == 1'b0) next_state = F;
                else           next_state = A;
                z = 1'b0;
            end
            E: begin
                if (w == 1'b0) next_state = E;
                else           next_state = D;
                z = 1'b1;
            end
            F: begin
                if (w == 1'b0) next_state = C;
                else           next_state = D;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

endmodule