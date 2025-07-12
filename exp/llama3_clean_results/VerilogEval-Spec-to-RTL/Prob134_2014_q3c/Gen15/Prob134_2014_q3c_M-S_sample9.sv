module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;

// Combinational logic for next state and output
always @ (*) begin
    case (y)
        3'b000: begin
            current_state = (x)? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            current_state = (x)? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            current_state = (x)? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            current_state = (x)? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            current_state = (x)? 3'b100 : 3'b011;
            z = 1'b1;
        end
        default: begin
            current_state = 3'b000;
            z = 1'b0;
        end
    endcase
end

// Sequential logic
always @ (posedge clk) begin
    // Intentionally left empty as current_state is already being updated in the combinational logic
end

assign Y0 = current_state[0];

endmodule