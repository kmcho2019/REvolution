module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

always @(state or r) begin
    case (state)
        2'b00: begin // state A
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // state B
            end else if (r[1] == 1'b1) begin
                next_state = 2'b10; // state C
            end else if (r[2] == 1'b1) begin
                next_state = 2'b11; // state D
            end else begin
                next_state = 2'b00; // state A
            end
        end
        2'b01: begin // state B
            if (r[0] == 1'b1) begin
                next_state = 2'b01; // state B
            end else begin
                next_state = 2'b00; // state A
            end
        end
        2'b10: begin // state C
            if (r[1] == 1'b1) begin
                next_state = 2'b10; // state C
            end else begin
                next_state = 2'b00; // state A
            end
        end
        default: begin // state D
            next_state = 2'b00; // state A
        end
    endcase
end

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= 2'b00; // reset to state A
    end else begin
        state <= next_state;
    end
end

always @(state) begin
    case (state)
        2'b00: begin // state A
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        2'b01: begin // state B
            g[0] = 1'b1;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
        2'b10: begin // state C
            g[0] = 1'b0;
            g[1] = 1'b1;
            g[2] = 1'b0;
        end
        default: begin // state D
            g[0] = 1'b0;
            g[1] = 1'b0;
            g[2] = 1'b0;
        end
    endcase
end

endmodule