module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg [1:0] lut_next_state [5:0];
reg [0:0] lut_output [5:0];

// Initialize LUT
initial begin
    lut_next_state[0] = 2'b01; // A -> B
    lut_next_state[1] = 2'b10; // B -> C
    lut_next_state[2] = 2'b11; // C -> E
    lut_next_state[3] = 2'b10; // D -> F
    lut_next_state[4] = 2'b11; // E -> E
    lut_next_state[5] = 2'b10; // F -> C
    lut_output[0] = 1'b0; // A
    lut_output[1] = 1'b0; // B
    lut_output[2] = 1'b0; // C
    lut_output[3] = 1'b0; // D
    lut_output[4] = 1'b1; // E
    lut_output[5] = 1'b1; // F
end

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        current_state <= 3'b000; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @ (*) begin
    case (current_state)
        3'b000: // A
            if (w) begin
                next_state = 3'b001; // A -> B
            end else begin
                next_state = 3'b000; // A -> A
            end
        3'b001: // B
            if (w) begin
                next_state = 3'b010; // B -> C
            end else begin
                next_state = 3'b011; // B -> D
            end
        3'b010: // C
            if (w) begin
                next_state = 3'b100; // C -> E
            end else begin
                next_state = 3'b011; // C -> D
            end
        3'b011: // D
            if (w) begin
                next_state = 3'b101; // D -> F
            end else begin
                next_state = 3'b000; // D -> A
            end
        3'b100: // E
            if (w) begin
                next_state = 3'b100; // E -> E
            end else begin
                next_state = 3'b011; // E -> D
            end
        3'b101: // F
            if (w) begin
                next_state = 3'b010; // F -> C
            end else begin
                next_state = 3'b011; // F -> D
            end
        default:
            next_state = 3'b000; // Default to state A
    endcase
end

// Output z
assign z = (current_state == 3'b100) || (current_state == 3'b101);

endmodule