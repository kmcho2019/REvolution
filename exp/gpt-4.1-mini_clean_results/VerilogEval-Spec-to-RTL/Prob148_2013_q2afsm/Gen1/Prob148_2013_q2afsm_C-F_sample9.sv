module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding
    localparam [1:0]
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11;

    reg [1:0] state, next_state;

    // State flip-flops with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic with priority and grant maintenance
    always @(*) begin
        case(state)
            A: begin
                // Priority: device 0 > device 1 > device 2
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
                // Maintain grant if device 0 continues requesting
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end

            C: begin
                // Maintain grant if device 1 continues requesting
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end

            D: begin
                // Maintain grant if device 2 continues requesting
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            default: next_state = A;
        endcase
    end

    // Output grant logic: grant one device based on state (one-hot)
    assign g = (state == B) ? 3'b001 :
               (state == C) ? 3'b010 :
               (state == D) ? 3'b100 :
                              3'b000;

endmodule