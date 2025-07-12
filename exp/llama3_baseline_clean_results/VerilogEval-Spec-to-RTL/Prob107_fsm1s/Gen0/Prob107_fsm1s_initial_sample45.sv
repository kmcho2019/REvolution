`define STATE_B 2'b00
`define STATE_A 2'b01

module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        `STATE_B: begin
            if (~in) begin
                next_state = `STATE_A;
            end else begin
                next_state = `STATE_B;
            end
        end
        `STATE_A: begin
            if (~in) begin
                next_state = `STATE_B;
            end else begin
                next_state = `STATE_A;
            end
        end
        default: begin
            next_state = `STATE_B;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= `STATE_B;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        `STATE_B: begin
            out = 1'b1;
        end
        `STATE_A: begin
            out = 1'b0;
        end
        default: begin
            out = 1'b1;
        end
    endcase
end

endmodule