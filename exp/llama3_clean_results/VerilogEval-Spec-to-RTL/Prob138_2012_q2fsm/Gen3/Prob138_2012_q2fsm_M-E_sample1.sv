module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [5:0] state;
reg [5:0] next_state;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        state <= 6'b000001; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// State table
always @ (*) begin
    case (1'b1)
        state[0]: // A
            if (w) begin
                next_state = 6'b000010; // A -> B
            end else begin
                next_state = 6'b000001; // A -> A
            end
        state[1]: // B
            if (w) begin
                next_state = 6'b000100; // B -> C
            end else begin
                next_state = 6'b001000; // B -> D
            end
        state[2]: // C
            if (w) begin
                next_state = 6'b100000; // C -> E
            end else begin
                next_state = 6'b001000; // C -> D
            end
        state[3]: // D
            if (w) begin
                next_state = 6'b010000; // D -> F
            end else begin
                next_state = 6'b000001; // D -> A
            end
        state[4]: // E
            if (w) begin
                next_state = 6'b100000; // E -> E
            end else begin
                next_state = 6'b001000; // E -> D
            end
        state[5]: // F
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
assign z = state[4] | state[5];

endmodule