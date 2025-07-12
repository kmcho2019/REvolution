// Define the states as an enum
`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] current_state;
reg [1:0] next_state;

always @(*) begin
    case(current_state)
        `A: begin
            if (!in) begin
                next_state = `A;
            end else begin
                next_state = `B;
            end
            out = 0;
        end
        `B: begin
            if (!in) begin
                next_state = `C;
            end else begin
                next_state = `B;
            end
            out = 0;
        end
        `C: begin
            if (!in) begin
                next_state = `A;
            end else begin
                next_state = `D;
            end
            out = 0;
        end
        `D: begin
            if (!in) begin
                next_state = `C;
            end else begin
                next_state = `B;
            end
            out = 1;
        end
        default: begin
            next_state = `A;
            out = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

endmodule