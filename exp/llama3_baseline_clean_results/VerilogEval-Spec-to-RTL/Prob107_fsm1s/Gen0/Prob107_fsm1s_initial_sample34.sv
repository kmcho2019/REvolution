`define STATE_A 1'b0
`define STATE_B 1'b1

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        `STATE_A: begin
            if(in == 1'b0) begin
                next_state = `STATE_B;
                out = 1'b0;
            end else begin
                next_state = `STATE_A;
                out = 1'b0;
            end
        end
        `STATE_B: begin
            if(in == 1'b0) begin
                next_state = `STATE_A;
                out = 1'b1;
            end else begin
                next_state = `STATE_B;
                out = 1'b1;
            end
        end
        default: begin
            next_state = `STATE_B;
            out = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        current_state <= `STATE_B;
    end else begin
        current_state <= next_state;
    end
end

initial begin
    current_state = `STATE_B;
end

endmodule