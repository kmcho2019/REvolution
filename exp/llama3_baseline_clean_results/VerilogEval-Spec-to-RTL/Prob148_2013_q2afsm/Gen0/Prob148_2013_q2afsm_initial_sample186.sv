module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        2'b00: begin
            if (r[0] == 1'b1) begin
                next_state = 2'b01;
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10;
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (r[0] == 1'b1) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b10: begin
            if (r[1] == 1'b1) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b11: begin
            if (r[2] == 1'b1) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b00;
            end
        end
        default: next_state = 2'b00;
    endcase
end

// Output logic
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = (state == 2'b11);

endmodule