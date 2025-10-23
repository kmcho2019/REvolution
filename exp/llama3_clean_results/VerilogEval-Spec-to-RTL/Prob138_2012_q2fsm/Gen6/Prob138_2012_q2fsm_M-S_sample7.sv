module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

// State encoding
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// State flip-flops and state table
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A; // Reset to state A
    end else begin
        case (current_state)
            A:
                if (w) begin
                    current_state <= B; // A -> B
                end else begin
                    current_state <= A; // A -> A
                end
            B:
                if (w) begin
                    current_state <= C; // B -> C
                end else begin
                    current_state <= D; // B -> D
                end
            C:
                if (w) begin
                    current_state <= E; // C -> E
                end else begin
                    current_state <= D; // C -> D
                end
            D:
                if (w) begin
                    current_state <= F; // D -> F
                end else begin
                    current_state <= A; // D -> A
                end
            E:
                if (w) begin
                    current_state <= E; // E -> E
                end else begin
                    current_state <= D; // E -> D
                end
            F:
                if (w) begin
                    current_state <= C; // F -> C
                end else begin
                    current_state <= D; // F -> D
                end
            default:
                current_state <= A; // Default to state A
        endcase
    end
end

// Output z
assign z = (current_state == E) || (current_state == F);

endmodule