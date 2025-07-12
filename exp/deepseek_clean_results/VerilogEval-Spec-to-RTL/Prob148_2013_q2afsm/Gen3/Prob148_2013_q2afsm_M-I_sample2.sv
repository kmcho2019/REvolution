module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // Gray-coded state definitions to minimize transitions
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b11;
    localparam D = 2'b10;

    reg [1:0] state, next_state;

    // State transition logic with parallel case
    always @(*) begin
        next_state = A;  // Default to state A
        case (state) // synthesis parallel_case
            A: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
            end
            B: next_state = r[0] ? B : A;
            C: next_state = r[1] ? C : A;
            D: next_state = r[2] ? D : A;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end else begin
            state <= next_state;
            // Registered outputs to prevent glitches
            g <= (next_state == B) ? 3'b001 :
                 (next_state == C) ? 3'b010 :
                 (next_state == D) ? 3'b100 : 3'b000;
        end
    end

endmodule