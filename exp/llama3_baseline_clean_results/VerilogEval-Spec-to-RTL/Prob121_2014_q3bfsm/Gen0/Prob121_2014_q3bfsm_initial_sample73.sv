module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // Current state
reg [2:0] next_y; // Next state
reg z_out; // Output z

// Combinational logic to determine next state and output z
always @(*) begin
    case (y)
        3'b000: begin
            next_y = (x == 1'b0) ? 3'b000 : 3'b001;
            z_out = 1'b0;
        end
        3'b001: begin
            next_y = (x == 1'b0) ? 3'b001 : 3'b100;
            z_out = 1'b0;
        end
        3'b010: begin
            next_y = (x == 1'b0) ? 3'b010 : 3'b001;
            z_out = 1'b0;
        end
        3'b011: begin
            next_y = (x == 1'b0) ? 3'b001 : 3'b010;
            z_out = 1'b1;
        end
        3'b100: begin
            next_y = (x == 1'b0) ? 3'b011 : 3'b100;
            z_out = 1'b1;
        end
        default: begin
            next_y = 3'b000;
            z_out = 1'b0;
        end
    endcase
end

// Sequential logic to update current state on positive edge of clock
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000; // Reset to state 000
    end else begin
        y <= next_y;
    end
end

assign z = z_out;

endmodule