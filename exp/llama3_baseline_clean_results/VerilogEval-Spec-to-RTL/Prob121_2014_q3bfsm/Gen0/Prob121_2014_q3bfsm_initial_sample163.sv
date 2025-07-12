module TopModule(
    input clk,
    input reset,
    input x,
    output z
);

reg [2:0] y; // current state
reg [2:0] next_y; // next state

// Combinational logic to determine next state and output
always @(*) begin
    case (y)
        3'b000: begin
            next_y = x ? 3'b001 : 3'b000;
            z = 1'b0;
        end
        3'b001: begin
            next_y = x ? 3'b100 : 3'b001;
            z = 1'b0;
        end
        3'b010: begin
            next_y = x ? 3'b001 : 3'b010;
            z = 1'b0;
        end
        3'b011: begin
            next_y = x ? 3'b010 : 3'b001;
            z = 1'b1;
        end
        3'b100: begin
            next_y = x ? 3'b100 : 3'b011;
            z = 1'b1;
        end
        default: begin
            next_y = 3'b000; // default next state
            z = 1'b0;
        end
    endcase
end

// Sequential logic to update current state
always @(posedge clk) begin
    if (reset) begin
        y <= 3'b000;
    end else begin
        y <= next_y;
    end
end

endmodule