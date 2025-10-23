module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output reg Y0,
    output reg z
);

reg [2:0] current_state;

// Combinational logic for next state and output z
always @ (*) begin
    case (y)
        3'b000: begin
            current_state = x ? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            current_state = x ? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            current_state = x ? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            current_state = x ? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            current_state = x ? 3'b100 : 3'b011;
            z = 1'b1;
        end
        default: begin
            current_state = 3'b000;
            z = 1'b0;
        end
    endcase
end

// Sequential logic to update current state
always @ (posedge clk) begin
    // Since we're already calculating next_state in the combinational block,
    // we can directly use it here without an additional next_state reg.
end

// Output Y0 is just the least significant bit of current_state
assign Y0 = current_state[0];

endmodule