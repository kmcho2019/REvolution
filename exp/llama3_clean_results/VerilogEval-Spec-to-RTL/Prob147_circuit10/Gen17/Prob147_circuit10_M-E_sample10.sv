module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg [1:0] current_state;

always @(posedge clk) begin
    case (current_state)
        2'b00: begin
            if (~a && b) begin
                current_state <= 2'b01;
            end else if (~b) begin
                current_state <= 2'b00;
            end
        end
        2'b01: begin
            if (a && b) begin
                current_state <= 2'b00;
            end else if (~a && ~b) begin
                current_state <= 2'b01;
            end else if (~b) begin
                current_state <= 2'b00;
            end else begin
                current_state <= 2'b01;
            end
        end
        default: current_state <= 2'b00;
    endcase
end

assign q = (current_state == 2'b01);
assign state = current_state[0];

endmodule