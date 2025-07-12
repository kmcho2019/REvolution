module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [1:0] current_state, next_state;

    // Combinational next state logic
    always @(*) begin
        case (current_state)
            2'b00: begin // IDLE
                if (r[0])      next_state = 2'b01;
                else if (r[1])  next_state = 2'b10;
                else if (r[2])  next_state = 2'b11;
                else            next_state = 2'b00;
            end
            2'b01: next_state = r[0] ? 2'b01 : 2'b00; // GRANT_0
            2'b10: next_state = r[1] ? 2'b10 : 2'b00; // GRANT_1
            2'b11: next_state = r[2] ? 2'b11 : 2'b00; // GRANT_2
            default: next_state = 2'b00;
        endcase
    end

    // Sequential state register
    always @(posedge clk) begin
        if (!resetn) begin
            current_state <= 2'b00;
        end else begin
            current_state <= next_state;
        end
    end

    // Output assignments
    assign g[0] = (current_state == 2'b01);
    assign g[1] = (current_state == 2'b10);
    assign g[2] = (current_state == 2'b11);

endmodule