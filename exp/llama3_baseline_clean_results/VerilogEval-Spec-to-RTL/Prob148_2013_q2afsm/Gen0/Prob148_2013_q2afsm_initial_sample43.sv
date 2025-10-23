module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    next_state = state;
    case (state)
        2'b00: begin
            if (r[0]) begin
                next_state = 2'b01;
            end else if (r[1]) begin
                next_state = 2'b10;
            end else if (r[2]) begin
                // State D is not used in this FSM, so we stay in state A
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (!r[0]) begin
                next_state = 2'b00;
            end
        end
        2'b10: begin
            if (!r[1]) begin
                next_state = 2'b00;
            end
        end
    endcase
end

// Output signals
assign g[0] = (state == 2'b01);
assign g[1] = (state == 2'b10);
assign g[2] = 1'b0;

endmodule