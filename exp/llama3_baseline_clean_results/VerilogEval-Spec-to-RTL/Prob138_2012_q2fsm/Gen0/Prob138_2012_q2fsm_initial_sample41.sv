module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State Flip-Flops
always @(posedge clk) begin
    if(reset) begin
        current_state <= 3'b001; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Next State Logic
always @(*) begin
    case(current_state)
        3'b001: // A
            if(w) begin
                next_state = 3'b010; // B
            end else begin
                next_state = 3'b001; // A
            end
        3'b010: // B
            if(w) begin
                next_state = 3'b011; // C
            end else begin
                next_state = 3'b100; // D
            end
        3'b011: // C
            if(w) begin
                next_state = 3'b101; // E
            end else begin
                next_state = 3'b100; // D
            end
        3'b100: // D
            if(w) begin
                next_state = 3'b110; // F
            end else begin
                next_state = 3'b001; // A
            end
        3'b101: // E
            if(w) begin
                next_state = 3'b101; // E
            end else begin
                next_state = 3'b100; // D
            end
        3'b110: // F
            if(w) begin
                next_state = 3'b011; // C
            end else begin
                next_state = 3'b100; // D
            end
        default:
            next_state = 3'b001; // Default to state A
    endcase
end

// Output Logic
always @(*) begin
    case(current_state)
        3'b001: z = 0; // A
        3'b010: z = 0; // B
        3'b011: z = 0; // C
        3'b100: z = 0; // D
        3'b101: z = 1; // E
        3'b110: z = 1; // F
        default: z = 0; // Default to 0
    endcase
end

endmodule