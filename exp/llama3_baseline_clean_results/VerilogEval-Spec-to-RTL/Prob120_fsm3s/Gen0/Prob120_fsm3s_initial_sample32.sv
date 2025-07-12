`define A 2'b00
`define B 2'b01
`define C 2'b10
`define D 2'b11

module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state;
reg [1:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= `A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        `A: begin
            if(!in) begin
                next_state = `A;
            end else begin
                next_state = `B;
            end
            out = 1'b0;
        end
        `B: begin
            if(!in) begin
                next_state = `C;
            end else begin
                next_state = `B;
            end
            out = 1'b0;
        end
        `C: begin
            if(!in) begin
                next_state = `A;
            end else begin
                next_state = `D;
            end
            out = 1'b0;
        end
        `D: begin
            if(!in) begin
                next_state = `C;
            end else begin
                next_state = `B;
            end
            out = 1'b1;
        end
    endcase
end

endmodule