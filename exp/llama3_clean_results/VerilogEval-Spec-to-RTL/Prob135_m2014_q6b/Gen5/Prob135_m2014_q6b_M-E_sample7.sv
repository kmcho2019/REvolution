module TopModule(y, w, Y1);
    input [2:0] y;
    input w;
    output Y1;

    assign Y1 = y[1];

    reg [1:0] next_y1;
    reg [2:0] current_state;

    always @(*) begin
        case (y)
            3'b000: current_state = 3'b000; // State A
            3'b001: current_state = 3'b001; // State B
            3'b010: current_state = 3'b010; // State C
            3'b011: current_state = 3'b011; // State D
            3'b100: current_state = 3'b100; // State E
            3'b101: current_state = 3'b101; // State F
            default: current_state = 3'b000; // Default state
        endcase

        case ({current_state, w})
            {3'b000, 1'b0}: next_y1 = 1'b0; // A to B
            {3'b000, 1'b1}: next_y1 = 1'b0; // A to A
            {3'b001, 1'b0}: next_y1 = 1'b0; // B to C
            {3'b001, 1'b1}: next_y1 = 1'b1; // B to D
            {3'b010, 1'b0}: next_y1 = 1'b1; // C to E
            {3'b010, 1'b1}: next_y1 = 1'b1; // C to D
            {3'b011, 1'b0}: next_y1 = 1'b0; // D to F
            {3'b011, 1'b1}: next_y1 = 1'b0; // D to A
            {3'b100, 1'b0}: next_y1 = 1'b1; // E to E
            {3'b100, 1'b1}: next_y1 = 1'b1; // E to D
            {3'b101, 1'b0}: next_y1 = 1'b0; // F to C
            {3'b101, 1'b1}: next_y1 = 1'b1; // F to D
            default: next_y1 = 1'b0;
        endcase
    end

    assign Y1 = next_y1;
endmodule