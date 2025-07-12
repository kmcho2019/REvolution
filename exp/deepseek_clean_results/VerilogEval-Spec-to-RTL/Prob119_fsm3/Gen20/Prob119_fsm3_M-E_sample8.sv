module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    // State encoding optimized for LUT implementation
    parameter [1:0] A = 2'b00,
                    B = 2'b01,
                    C = 2'b10,
                    D = 2'b11;

    reg [1:0] current_state;
    wire [1:0] next_state;

    // LUT for state transitions (acts as a ROM)
    always @(*) begin
        case ({current_state, in})
            3'b000: next_state = A;  // A,0->A
            3'b001: next_state = B;  // A,1->B
            3'b010: next_state = C;  // B,0->C
            3'b011: next_state = B;  // B,1->B
            3'b100: next_state = A;  // C,0->A
            3'b101: next_state = D;  // C,1->D
            3'b110: next_state = C;  // D,0->C
            3'b111: next_state = B;  // D,1->B
            default: next_state = A; // Default to A
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    // Moore output logic
    assign out = (current_state == D);

endmodule