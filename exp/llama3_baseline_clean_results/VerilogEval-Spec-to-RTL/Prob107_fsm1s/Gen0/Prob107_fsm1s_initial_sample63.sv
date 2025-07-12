module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state, next_state;

// State encoding: B = 2'b00, A = 2'b01

always @(*) begin
    case(state)
        2'b00: begin
            if (~in) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (~in) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        default: begin
            next_state = 2'b00;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        2'b00: out = 1'b1;
        2'b01: out = 1'b0;
        default: out = 1'b0;
    endcase
end

initial state = 2'b00;

endmodule