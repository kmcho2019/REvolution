module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

reg [1:0] current_state, next_state;

always @(posedge clk) begin
    current_state <= next_state;
end

always @(*) begin
    case (current_state)
        2'b00: begin
            if (~a && b) begin
                next_state = 2'b01;
            end else if (a && b) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (a && b) begin
                next_state = 2'b01;
            end else if (~a && ~b) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin
            if (~a && b) begin
                next_state = 2'b01;
            end else if (a && ~b) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b10;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

always @(*) begin
    case (current_state)
        2'b00: begin
            q = (a && ~b);
            state = 1'b0;
        end
        2'b01: begin
            q = 1'b1;
            state = 1'b0;
        end
        2'b10: begin
            q = 1'b1;
            state = 1'b1;
        end
        default: begin
            q = 1'b0;
            state = 1'b0;
        end
    endcase
end

initial begin
    current_state = 2'b00;
end

endmodule