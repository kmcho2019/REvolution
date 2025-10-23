module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= 3'b000; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        3'b000: // State A
            if(!w) begin
                next_state = 3'b001; // Go to state B
                z = 0;
            end else begin
                next_state = 3'b000; // Stay in state A
                z = 0;
            end
        3'b001: // State B
            if(!w) begin
                next_state = 3'b010; // Go to state C
                z = 0;
            end else begin
                next_state = 3'b011; // Go to state D
                z = 0;
            end
        3'b010: // State C
            if(!w) begin
                next_state = 3'b100; // Go to state E
                z = 0;
            end else begin
                next_state = 3'b011; // Go to state D
                z = 0;
            end
        3'b011: // State D
            if(!w) begin
                next_state = 3'b101; // Go to state F
                z = 0;
            end else begin
                next_state = 3'b000; // Go to state A
                z = 0;
            end
        3'b100: // State E
            if(w) begin
                next_state = 3'b011; // Go to state D
                z = 1;
            end else begin
                next_state = 3'b100; // Stay in state E
                z = 1;
            end
        3'b101: // State F
            if(w) begin
                next_state = 3'b011; // Go to state D
                z = 1;
            end else begin
                next_state = 3'b010; // Go to state C
                z = 1;
            end
        default:
            next_state = 3'b000; // Default to state A
            z = 0;
    endcase
end

endmodule