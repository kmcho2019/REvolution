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
    reg [2:0] g_next;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            state <= A;
        else
            state <= next_state;
    end

    // Next-state logic
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

    // Output next-state logic combinational
    always @(*) begin
        case (state)
            B: g_next = 3'b001;
            C: g_next = 3'b010;
            D: g_next = 3'b100;
            default: g_next = 3'b000;
        endcase
    end

    // Registered output
    always @(posedge clk) begin
        if (~resetn)
            g <= 3'b000;
        else
            g <= g_next;
    end

endmodule