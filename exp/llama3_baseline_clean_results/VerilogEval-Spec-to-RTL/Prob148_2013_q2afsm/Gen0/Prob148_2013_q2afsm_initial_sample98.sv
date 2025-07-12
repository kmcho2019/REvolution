module TopModule(
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

reg [1:0] state;
reg [1:0] next_state;

// Output logic
always @(*) begin
    case(state)
        2'b00: begin // State A
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
        2'b01: begin // State B
            g[0] = 1;
            g[1] = 0;
            g[2] = 0;
        end
        2'b10: begin // State C
            g[0] = 0;
            g[1] = 1;
            g[2] = 0;
        end
        default: begin // State D (not used)
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
    endcase
end

// State table
always @(*) begin
    case(state)
        2'b00: begin // State A
            if(r[0] == 1'b1) begin
                next_state = 2'b01;
            end else if(r[1] == 1'b1) begin
                next_state = 2'b10;
            end else if(r[2] == 1'b1) begin
                next_state = 2'b00; // No transition to state D, stay in A
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // State B
            if(r[0] == 1'b1) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b10: begin // State C
            if(r[1] == 1'b1) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b00;
            end
        end
        default: begin // State D (not used)
            next_state = 2'b00;
        end
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(~resetn) begin
        state <= 2'b00; // Reset to state A
    end else begin
        state <= next_state;
    end
end

endmodule