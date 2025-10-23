module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Current state decoder
reg [2:0] current_state;
always @(y) begin
    case (y)
        6'b000001: current_state = 3'b000;
        6'b000010: current_state = 3'b001;
        6'b000100: current_state = 3'b010;
        6'b001000: current_state = 3'b011;
        6'b010000: current_state = 3'b100;
        6'b100000: current_state = 3'b101;
        default: current_state = 3'b000;
    endcase
end

// Next state encoder
always @(current_state or w) begin
    case (current_state)
        3'b000: begin
            if (~w) Y1 = 1; else Y1 = 0;
            if (w) Y3 = 0; else Y3 = 0;
        end
        3'b001: begin
            if (~w) Y1 = 0; else Y1 = 0;
            if (w) Y3 = 1; else Y3 = 0;
        end
        3'b010: begin
            if (~w) Y1 = 0; else Y1 = 0;
            if (w) Y3 = 0; else Y3 = 1;
        end
        3'b011: begin
            if (~w) Y1 = 0; else Y1 = 0;
            if (w) Y3 = 0; else Y3 = 0;
        end
        3'b100: begin
            if (~w) Y1 = 0; else Y1 = 0;
            if (w) Y3 = 0; else Y3 = 0;
        end
        3'b101: begin
            if (~w) Y1 = 0; else Y1 = 0;
            if (w) Y3 = 0; else Y3 = 0;
        end
        default: begin
            Y1 = 0;
            Y3 = 0;
        end
    endcase
end

endmodule