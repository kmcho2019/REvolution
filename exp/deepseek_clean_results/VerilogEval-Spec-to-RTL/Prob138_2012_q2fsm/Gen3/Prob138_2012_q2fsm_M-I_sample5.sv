module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Gray code state encoding (only one bit changes between adjacent states)
    localparam [2:0] A = 3'b000;
    localparam [2:0] B = 3'b001;
    localparam [2:0] C = 3'b011;
    localparam [2:0] D = 3'b010;
    localparam [2:0] E = 3'b110;
    localparam [2:0] F = 3'b111;

    reg [2:0] current_state, next_state;

    // State transition logic (combinational)
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
        endcase
    end

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output logic (z is 1 in states E and F)
    assign z = (current_state == E) | (current_state == F);

endmodule