module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// One-hot state encoding
localparam A = 3'b001;
localparam B = 3'b010;
localparam C = 3'b100;
localparam D = 3'b000;
localparam E = 3'b011;
localparam F = 3'b101;

// State flip-flops
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// State table
always @ (*) begin
    case (current_state)
        A:
            if (w) begin
                next_state = B; // A -> B
            end else begin
                next_state = A; // A -> A
            end
        B:
            if (w) begin
                next_state = C; // B -> C
            end else begin
                next_state = D; // B -> D
            end
        C:
            if (w) begin
                next_state = E; // C -> E
            end else begin
                next_state = D; // C -> D
            end
        D:
            if (w) begin
                next_state = F; // D -> F
            end else begin
                next_state = A; // D -> A
            end
        E:
            if (w) begin
                next_state = E; // E -> E
            end else begin
                next_state = D; // E -> D
            end
        F:
            if (w) begin
                next_state = C; // F -> C
            end else begin
                next_state = D; // F -> D
            end
        default:
            next_state = A; // Default to state A
    endcase
end

// Output z
assign z = (current_state == E) || (current_state == F);

endmodule