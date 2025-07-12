module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

// Define constants for each state
parameter STATE_A = 6'b000001;
parameter STATE_B = 6'b000010;
parameter STATE_C = 6'b000100;
parameter STATE_D = 6'b001000;
parameter STATE_E = 6'b010000;
parameter STATE_F = 6'b100000;

// Use a case statement to handle the different states and their corresponding next states
always @(*) begin
    case (y)
        STATE_A: begin
            Y1 = w;
            Y3 = 1'b0;
        end
        STATE_B: begin
            Y1 = 1'b0;
            Y3 = ~w;
        end
        STATE_C: begin
            Y1 = 1'b0;
            Y3 = ~w;
        end
        STATE_D: begin
            Y1 = 1'b0;
            Y3 = ~w;
        end
        STATE_E: begin
            Y1 = 1'b0;
            Y3 = ~w;
        end
        STATE_F: begin
            Y1 = w;
            Y3 = 1'b0;
        end
        default: begin
            Y1 = 1'b0;
            Y3 = 1'b0;
        end
    endcase
end

endmodule