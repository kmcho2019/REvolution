module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] next_g;

    // State register and outputs registered on clock edge with synchronous reset
    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            state <= next_state;
            g <= next_g;
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (state)
            A: begin
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
                if (r[0])
                    next_state = B;
                else
                    next_state = A;
            end

            C: begin
                if (r[1])
                    next_state = C;
                else
                    next_state = A;
            end

            D: begin
                if (r[2])
                    next_state = D;
                else
                    next_state = A;
            end

            default: next_state = A;
        endcase
    end

    // Output logic combinational
    always @(*) begin
        case (state)
            A: next_g = 3'b000;
            B: next_g = 3'b001;
            C: next_g = 3'b010;
            D: next_g = 3'b100;
            default: next_g = 3'b000;
        endcase
    end

endmodule