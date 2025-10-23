module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [1:0] state; // 2 states, so we need 2 bits
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // state A
            if(in == 1'b0) begin
                next_state = 2'b01; // move to state B
                out = 1'b0;
            end else begin
                next_state = 2'b00; // stay in state A
                out = 1'b0;
            end
        end
        2'b01: begin // state B
            if(in == 1'b0) begin
                next_state = 2'b00; // move to state A
                out = 1'b1;
            end else begin
                next_state = 2'b01; // stay in state B
                out = 1'b1;
            end
        end
        default: begin
            next_state = 2'b01; // default to state B
            out = 1'b1;
        end
    endcase
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= 2'b01; // reset to state B
    end else begin
        state <= next_state;
    end
end

endmodule