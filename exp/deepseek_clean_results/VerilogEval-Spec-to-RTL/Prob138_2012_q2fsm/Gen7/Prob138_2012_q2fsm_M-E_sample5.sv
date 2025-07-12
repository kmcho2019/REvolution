module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Binary state encoding
    localparam [2:0] A = 3'b000;
    localparam [2:0] B = 3'b001;
    localparam [2:0] C = 3'b010;
    localparam [2:0] D = 3'b011;
    localparam [2:0] E = 3'b100;
    localparam [2:0] F = 3'b101;

    reg [2:0] current_state, next_state;
    reg z_next;

    // Synchronous reset handling
    reg reset_sync1, reset_sync2;
    always @(posedge clk) begin
        reset_sync1 <= reset;
        reset_sync2 <= reset_sync1;
    end

    // Next state logic
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

    // Output logic (combinatorial)
    always @(*) begin
        z_next = (current_state == E) | (current_state == F);
    end

    // State and output registers
    always @(posedge clk) begin
        if (reset_sync2) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= z_next;
        end
    end

endmodule