module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

    localparam [2:0] A=3'd0, B=3'd1, C=3'd2, D=3'd3, E=3'd4, F=3'd5;

    reg [2:0] state, next_state;
    reg next_z;

    // Combinational logic for next state and output z
    always @(*) begin
        case (state)
            A: begin
                if (w)
                    next_state = A;
                else
                    next_state = B;
                next_z = 1'b0;
            end
            B: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                next_z = 1'b0;
            end
            C: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                next_z = 1'b0;
            end
            D: begin
                if (w)
                    next_state = A;
                else
                    next_state = F;
                next_z = 1'b0;
            end
            E: begin
                if (w)
                    next_state = D;
                else
                    next_state = E;
                next_z = 1'b1;
            end
            F: begin
                if (w)
                    next_state = D;
                else
                    next_state = C;
                next_z = 1'b1;
            end
            default: begin
                next_state = A;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic for state and output registers
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule