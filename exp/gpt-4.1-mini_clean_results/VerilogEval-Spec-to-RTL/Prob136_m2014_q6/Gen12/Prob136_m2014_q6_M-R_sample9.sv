module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    localparam A = 3'd0, B = 3'd1, C = 3'd2, D = 3'd3, E = 3'd4, F = 3'd5;
    reg [2:0] state, next_state;

    // Combinational next state and output logic
    always @(*) begin
        case (state)
            A: begin
                next_state = (w == 1'b0) ? B : A;
                z = 1'b0;
            end
            B: begin
                next_state = (w == 1'b0) ? C : D;
                z = 1'b0;
            end
            C: begin
                next_state = (w == 1'b0) ? E : D;
                z = 1'b0;
            end
            D: begin
                next_state = (w == 1'b0) ? F : A;
                z = 1'b0;
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
                z = 1'b0;
            end
        endcase
    end

    // Sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule