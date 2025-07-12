module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] current_state;
reg [5:0] next_state;

// Initialize current state to A (one-hot encoding)
initial begin
    current_state = 6'b1; // State A
end

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        current_state <= 6'b1; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @ (*) begin
    case (1'b1) // Use one-hot encoding
        current_state[0]: // State A
            if (w) begin
                next_state = 6'b10; // A -> B
            end else begin
                next_state = 6'b1; // A -> A
            end
        current_state[1]: // State B
            if (w) begin
                next_state = 6'b100; // B -> C
            end else begin
                next_state = 6'b1000; // B -> D
            end
        current_state[2]: // State C
            if (w) begin
                next_state = 6'b10000; // C -> E
            end else begin
                next_state = 6'b1000; // C -> D
            end
        current_state[3]: // State D
            if (w) begin
                next_state = 6'b100000; // D -> F
            end else begin
                next_state = 6'b1; // D -> A
            end
        current_state[4]: // State E
            if (w) begin
                next_state = 6'b10000; // E -> E
            end else begin
                next_state = 6'b1000; // E -> D
            end
        current_state[5]: // State F
            if (w) begin
                next_state = 6'b100; // F -> C
            end else begin
                next_state = 6'b1000; // F -> D
            end
        default:
            next_state = 6'b1; // Default to state A
    endcase
end

// Output z
assign z = (current_state[4] || current_state[5]); // States E and F

endmodule