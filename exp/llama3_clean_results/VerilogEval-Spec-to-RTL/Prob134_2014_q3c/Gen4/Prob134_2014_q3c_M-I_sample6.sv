module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg output_z;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    case (current_state)
        3'b000: begin
            if (x == 1'b0) next_state = 3'b000;
            else next_state = 3'b001;
            output_z = 1'b0;
        end
        3'b001: begin
            if (x == 1'b0) next_state = 3'b001;
            else next_state = 3'b100;
            output_z = 1'b0;
        end
        3'b010: begin
            if (x == 1'b0) next_state = 3'b010;
            else next_state = 3'b001;
            output_z = 1'b0;
        end
        3'b011: begin
            if (x == 1'b0) next_state = 3'b001;
            else next_state = 3'b010;
            output_z = 1'b1;
        end
        3'b100: begin
            if (x == 1'b0) next_state = 3'b011;
            else next_state = 3'b100;
            output_z = 1'b1;
        end
        default: begin
            next_state = current_state;
            output_z = 1'b0;
        end
    endcase
end

assign Y0 = next_state[0];
assign z = output_z;

initial begin
    current_state = 3'b000;
end

endmodule