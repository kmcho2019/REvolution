module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state, next_state;

// state flip-flops
always @(posedge clk) begin
    if (~resetn) begin
        state <= 2'b00; // reset to state A
    end else begin
        state <= next_state;
    end
end

// state table (next state logic)
always @(*) begin
    case (state)
        2'b00: // state A
            if (~r[0] && ~r[1] && ~r[2]) begin
                next_state = 2'b00;
            end else if (r[0]) begin
                next_state = 2'b01;
            end else if (r[1]) begin
                next_state = 2'b10;
            end else if (r[2]) begin
                next_state = 2'b11;
            end
        2'b01: // state B
            if (r[0]) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        2'b10: // state C
            if (r[1]) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00;
            end
        2'b11: // state D
            if (~r[0] && ~r[1] && r[2]) begin
                next_state = 2'b11;
            end else if (~r[2]) begin
                next_state = 2'b00;
            end else if (r[0]) begin
                next_state = 2'b01;
            end else if (r[1]) begin
                next_state = 2'b10;
            end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

// output logic
assign g[0] = (state == 2'b01) || (state == 2'b01 && r[0]);
assign g[1] = (state == 2'b10) || (state == 2'b10 && r[1]);
assign g[2] = (state == 2'b11) || (state == 2'b11 && r[2]);

endmodule