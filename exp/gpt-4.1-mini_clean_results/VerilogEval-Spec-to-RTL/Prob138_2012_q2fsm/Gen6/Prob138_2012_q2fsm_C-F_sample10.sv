module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // State encoding using 3-bit binary encoding
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5;

    reg [2:0] current_state, next_state;

    // State flip-flops with synchronous active-high reset
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            // Output z registered as 1 in states E or F, else 0
            z <= (next_state == E) || (next_state == F);
        end
    end

    // Next state combinational logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

endmodule