module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @ (*) begin
    case (state)
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
always @ (*) begin
    if (state == 3'b100 || state == 3'b101) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule