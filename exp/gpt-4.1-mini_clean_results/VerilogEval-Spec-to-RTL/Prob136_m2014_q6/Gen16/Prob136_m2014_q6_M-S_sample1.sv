module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding
    parameter A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5;

    reg [2:0] state, next_state;

    always @(*) begin
        z = 1'b0; // default output
        case (state)
            A: begin
                next_state = (w == 1'b0) ? B : A;
            end
            B: begin
                next_state = (w == 1'b0) ? C : D;
            end
            C: begin
                next_state = (w == 1'b0) ? E : D;
            end
            D: begin
                next_state = (w == 1'b0) ? F : A;
            end
            E: begin
                next_state = (w == 1'b0) ? E : D;
                z = 1'b1;
            end
            F: begin
                next_state = (w == 1'b0) ? C : D;
                z = 1'b1;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule