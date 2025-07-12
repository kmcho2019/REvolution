module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

reg [0:0] state; // state variable

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset to state B
    end else begin
        case(state)
            1'b0: begin // state A
                if(in == 1'b1) begin
                    state <= 1'b0; // stay in state A
                end else begin
                    state <= 1'b1; // transition to state B
                end
            end
            1'b1: begin // state B
                if(in == 1'b1) begin
                    state <= 1'b1; // stay in state B
                end else begin
                    state <= 1'b0; // transition to state A
                end
            end
            default: state <= 1'b1;
        endcase
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // output for state A
        1'b1: out = 1'b1; // output for state B
        default: out = 1'b1;
    endcase
end

endmodule