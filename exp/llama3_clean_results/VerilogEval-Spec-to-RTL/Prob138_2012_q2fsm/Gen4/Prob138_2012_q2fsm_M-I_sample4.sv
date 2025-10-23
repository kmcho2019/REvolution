module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// State encoding: one-hot encoding
reg [5:0] current_state;
reg [5:0] next_state;

// Reset state: A
initial current_state = 6'b000001;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        current_state <= 6'b000001; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @ (*) begin
    case (1'b1)
        current_state[0]: // A
            if (w) begin
                next_state = 6'b000010; // A -> B
            end else begin
                next_state = 6'b000001; // A -> A
            end
        current_state[1]: // B
            if (w) begin
                next_state = 6'b000100; // B -> C
            end else begin
                next_state = 6'b001000; // B -> D
            end
        current_state[2]: // C
            if (w) begin
                next_state = 6'b010000; // C -> E
            end else begin
                next_state = 6'b001000; // C -> D
            end
        current_state[3]: // D
            if (w) begin
                next_state = 6'b100000; // D -> F
            end else begin
                next_state = 6'b000001; // D -> A
            end
        current_state[4]: // E
            if (w) begin
                next_state = 6'b010000; // E -> E
            end else begin
                next_state = 6'b001000; // E -> D
            end
        current_state[5]: // F
            if (w) begin
                next_state = 6'b000100; // F -> C
            end else begin
                next_state = 6'b001000; // F -> D
            end
        default:
            next_state = 6'b000001; // Default to state A
    endcase
end

// Output z
assign z = current_state[4] || current_state[5];

endmodule