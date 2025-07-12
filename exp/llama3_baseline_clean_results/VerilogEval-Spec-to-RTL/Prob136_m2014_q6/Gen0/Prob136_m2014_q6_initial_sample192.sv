`define A 6'b000001
`define B 6'b000010
`define C 6'b000100
`define D 6'b001000
`define E 6'b010000
`define F 6'b100000

module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

reg [5:0] current_state;
reg [5:0] next_state;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

always @ (*) begin
    case (current_state)
        `A: begin
            if (w) begin
                next_state = `A;
            end else begin
                next_state = `B;
            end
        end
        `B: begin
            if (w) begin
                next_state = `D;
            end else begin
                next_state = `C;
            end
        end
        `C: begin
            if (w) begin
                next_state = `D;
            end else begin
                next_state = `E;
            end
        end
        `D: begin
            if (w) begin
                next_state = `A;
            end else begin
                next_state = `F;
            end
        end
        `E: begin
            if (w) begin
                next_state = `D;
            end else begin
                next_state = `E;
            end
        end
        `F: begin
            if (w) begin
                next_state = `D;
            end else begin
                next_state = `C;
            end
        end
        default: next_state = `A;
    endcase
end

always @ (*) begin
    case (current_state)
        `A, `B, `C, `D: z = 0;
        `E, `F: z = 1;
        default: z = 0;
    endcase
end

endmodule