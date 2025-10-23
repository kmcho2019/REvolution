module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @ (posedge clk) begin
    current_state <= next_state;
end

always @ (*) begin
    case (current_state)
        3'b000: begin
            if (~x) begin
                next_state = 3'b000;
            end else begin
                next_state = 3'b001;
            end
            z = 1'b0;
        end
        3'b001: begin
            if (~x) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b100;
            end
            z = 1'b0;
        end
        3'b010: begin
            if (~x) begin
                next_state = 3'b010;
            end else begin
                next_state = 3'b001;
            end
            z = 1'b0;
        end
        3'b011: begin
            if (~x) begin
                next_state = 3'b001;
            end else begin
                next_state = 3'b010;
            end
            z = 1'b1;
        end
        3'b100: begin
            if (~x) begin
                next_state = 3'b011;
            end else begin
                next_state = 3'b100;
            end
            z = 1'b1;
        end
        default: begin
            next_state = 3'b000;
            z = 1'b0;
        end
    endcase
    Y0 = next_state[0];
end

endmodule