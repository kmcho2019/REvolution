module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding as parameters
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] state, next_state;

    // Next-state and output combinational logic
    always @(*) begin
        case (state)
            A: begin
                next_state = w ? A : B;
                z = 1'b0;
            end
            B: begin
                next_state = w ? D : C;
                z = 1'b0;
            end
            C: begin
                next_state = w ? D : E;
                z = 1'b0;
            end
            D: begin
                next_state = w ? A : F;
                z = 1'b0;
            end
            E: begin
                next_state = w ? D : E;
                z = 1'b1;
            end
            F: begin
                next_state = w ? D : C;
                z = 1'b1;
            end
            default: begin
                next_state = A;
                z = 1'b0;
            end
        endcase
    end

    // Sequential state update with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule