`define A 5'b00001
`define B 5'b00010
`define C 5'b00100
`define D 5'b01000
`define E 5'b10000
`define F 5'b10001

module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [4:0] current_state;
reg [4:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= `A;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        `A: begin
            if(w) begin
                next_state = `A;
                z = 0;
            end else begin
                next_state = `B;
                z = 0;
            end
        end
        `B: begin
            if(w) begin
                next_state = `D;
                z = 0;
            end else begin
                next_state = `C;
                z = 0;
            end
        end
        `C: begin
            if(w) begin
                next_state = `D;
                z = 0;
            end else begin
                next_state = `E;
                z = 0;
            end
        end
        `D: begin
            if(w) begin
                next_state = `A;
                z = 0;
            end else begin
                next_state = `F;
                z = 0;
            end
        end
        `E: begin
            if(w) begin
                next_state = `D;
                z = 1;
            end else begin
                next_state = `E;
                z = 1;
            end
        end
        `F: begin
            if(w) begin
                next_state = `D;
                z = 1;
            end else begin
                next_state = `C;
                z = 1;
            end
        end
        default: begin
            next_state = `A;
            z = 0;
        end
    endcase
end

endmodule