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

// State table using transition matrix
always @ (*) begin
    case (1'b1)
        state[0]: // A
            next_state = w ? 6'b000010 : 6'b000001;
        state[1]: // B
            next_state = w ? 6'b000100 : 6'b000011;
        state[2]: // C
            next_state = w ? 6'b001000 : 6'b000011;
        state[3]: // D
            next_state = w ? 6'b010000 : 6'b000001;
        state[4]: // E
            next_state = w ? 6'b001000 : 6'b000011;
        state[5]: // F
            next_state = w ? 6'b000100 : 6'b000011;
        default:
            next_state = 6'b000001; // Default to state A
    endcase
end

// Output z
assign z = state[4] | state[5]; // z is high when state is E or F

endmodule