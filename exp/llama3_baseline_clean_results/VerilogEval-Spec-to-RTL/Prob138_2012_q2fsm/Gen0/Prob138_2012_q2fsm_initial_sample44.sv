module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'b000; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        3'b000: begin // State A
            if(w) begin
                next_state = 3'b001; // A (0) --1--> B
            end else begin
                next_state = 3'b000; // A (0) --0--> A
            end
        end
        3'b001: begin // State B
            if(w) begin
                next_state = 3'b010; // B (0) --1--> C
            end else begin
                next_state = 3'b011; // B (0) --0--> D
            end
        end
        3'b010: begin // State C
            if(w) begin
                next_state = 3'b100; // C (0) --1--> E
            end else begin
                next_state = 3'b011; // C (0) --0--> D
            end
        end
        3'b011: begin // State D
            if(w) begin
                next_state = 3'b101; // D (0) --1--> F
            end else begin
                next_state = 3'b000; // D (0) --0--> A
            end
        end
        3'b100: begin // State E
            if(w) begin
                next_state = 3'b100; // E (1) --1--> E
            end else begin
                next_state = 3'b011; // E (1) --0--> D
            end
        end
        3'b101: begin // State F
            if(w) begin
                next_state = 3'b010; // F (1) --1--> C
            end else begin
                next_state = 3'b011; // F (1) --0--> D
            end
        end
        default: begin
            next_state = 3'b000; // Default state
        end
    endcase
end

assign z = (state == 3'b100) | (state == 3'b101); // z is 1 when in state E or F

endmodule