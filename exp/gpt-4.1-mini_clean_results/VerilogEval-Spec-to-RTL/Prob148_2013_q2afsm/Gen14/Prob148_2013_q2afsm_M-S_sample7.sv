module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Sequential state register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Combined next state and output logic
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
                g = 3'b000;
            end
            B: begin
                next_state = r[0] ? B : A;
                g = 3'b001;
            end
            C: begin
                next_state = r[1] ? C : A;
                g = 3'b010;
            end
            D: begin
                next_state = r[2] ? D : A;
                g = 3'b100;
            end
            default: begin
                next_state = A;
                g = 3'b000;
            end
        endcase
    end

endmodule