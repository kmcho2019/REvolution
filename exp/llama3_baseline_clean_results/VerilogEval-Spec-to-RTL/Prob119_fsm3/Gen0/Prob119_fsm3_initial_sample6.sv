`define STATE_A 2'b00
`define STATE_B 2'b01
`define STATE_C 2'b10
`define STATE_D 2'b11

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= `STATE_A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        `STATE_A: begin
            if (in == 0) begin
                next_state = `STATE_A;
            end else begin
                next_state = `STATE_B;
            end
            out = 0;
        end
        `STATE_B: begin
            if (in == 0) begin
                next_state = `STATE_C;
            end else begin
                next_state = `STATE_B;
            end
            out = 0;
        end
        `STATE_C: begin
            if (in == 0) begin
                next_state = `STATE_A;
            end else begin
                next_state = `STATE_D;
            end
            out = 0;
        end
        `STATE_D: begin
            if (in == 0) begin
                next_state = `STATE_C;
            end else begin
                next_state = `STATE_B;
            end
            out = 1;
        end
        default: begin
            next_state = `STATE_A;
            out = 0;
        end
    endcase
end

endmodule