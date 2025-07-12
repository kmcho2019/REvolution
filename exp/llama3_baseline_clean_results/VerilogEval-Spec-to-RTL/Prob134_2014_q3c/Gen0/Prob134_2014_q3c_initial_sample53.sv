module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;
reg z_out;

assign z = z_out;
assign Y0 = next_state[0]; // Directly assign Y0 from next_state

always @(*) begin
    case(current_state)
        3'b000: begin
            if (!x) next_state = 3'b000;
            else next_state = 3'b001;
            z_out = 1'b0;
        end
        3'b001: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b100;
            z_out = 1'b0;
        end
        3'b010: begin
            if (!x) next_state = 3'b010;
            else next_state = 3'b001;
            z_out = 1'b0;
        end
        3'b011: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b010;
            z_out = 1'b1;
        end
        3'b100: begin
            if (!x) next_state = 3'b011;
            else next_state = 3'b100;
            z_out = 1'b1;
        end
        default: begin
            next_state = 3'b000; // Default next state if current state is not defined
            z_out = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    current_state <= next_state;
end

initial begin
    current_state <= 3'b000; // Initialize state to 000 at power-up
end

endmodule