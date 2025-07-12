module TopModule(
    input  clk,
    input  x,
    input  [2:0] y,
    output Y0,
    output reg z
);

reg [2:0] current_state;

// Sequential logic
always @ (posedge clk) begin
    case (current_state)
        3'b000: current_state <= (x)? 3'b001 : 3'b000;
        3'b001: current_state <= (x)? 3'b100 : 3'b001;
        3'b010: current_state <= (x)? 3'b001 : 3'b010;
        3'b011: current_state <= (x)? 3'b010 : 3'b001;
        3'b100: current_state <= (x)? 3'b100 : 3'b011;
        default: current_state <= 3'b000;
    endcase
end

// Combinational logic for output
always @ (current_state, y, x) begin
    case (current_state)
        3'b000: begin
            Y0 = (x)? 1'b1 : 1'b0;
            z = 1'b0;
        end
        3'b001: begin
            Y0 = (x)? 1'b1 : 1'b0;
            z = 1'b0;
        end
        3'b010: begin
            Y0 = (x)? 1'b0 : 1'b0;
            z = 1'b0;
        end
        3'b011: begin
            Y0 = (x)? 1'b0 : 1'b0;
            z = 1'b1;
        end
        3'b100: begin
            Y0 = (x)? 1'b1 : 1'b0;
            z = 1'b1;
        end
        default: begin
            Y0 = 1'b0;
            z = 1'b0;
        end
    endcase
end

endmodule