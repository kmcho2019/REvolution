module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // State encoding using localparam for readability
    localparam A = 2'b00; // idle
    localparam B = 2'b01; // grant device 0
    localparam C = 2'b10; // grant device 1
    localparam D = 2'b11; // grant device 2

    reg [1:0] state, next_state;

    // Synchronous reset and state update (active low reset)
    always @(posedge clk) begin
        if (!resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
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

    // Output logic as separate always block
    always @(*) begin
        case(state)
            B: g = 3'b001; // grant device 0
            C: g = 3'b010; // grant device 1
            D: g = 3'b100; // grant device 2
            default: g = 3'b000; // no grant
        endcase
    end

endmodule