`define A 3'b000
`define B 3'b001
`define C 3'b010
`define D 3'b011
`define E 3'b100
`define F 3'b101

module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] current_state;
reg [2:0] next_state;

always @(posedge clk) begin
    if (reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
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
    endcase
end

always @(*) begin
    case (current_state)
        `A: z = 0;
        `B: z = 0;
        `C: z = 0;
        `D: z = 0;
        `E: z = 1;
        `F: z = 1;
    endcase
end

endmodule