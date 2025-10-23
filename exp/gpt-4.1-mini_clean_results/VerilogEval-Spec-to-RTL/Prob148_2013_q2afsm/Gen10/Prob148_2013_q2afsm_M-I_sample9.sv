module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding (2 bits)
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Next-state and combinational logic combined for clarity
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

            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
            default: next_state = A;
        endcase
    end

    // Clock enable - enable state update only if state changes or on reset
    wire ce = (state != next_state);

    // State register with synchronous active-low reset and clock enable
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else if (ce)
            state <= next_state;
    end

    // Registered output 'g' to reduce glitches and switching power
    always @(posedge clk) begin
        if (~resetn)
            g <= 3'b000;
        else begin
            case (state)
                B: g <= 3'b001;
                C: g <= 3'b010;
                D: g <= 3'b100;
                default: g <= 3'b000;
            endcase
        end
    end

endmodule