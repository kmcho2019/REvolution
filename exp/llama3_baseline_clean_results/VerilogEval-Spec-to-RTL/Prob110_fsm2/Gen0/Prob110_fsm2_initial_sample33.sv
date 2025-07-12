module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] state = 2'b00; // OFF state is 2'b00, ON state is 2'b01

always @(posedge clk or posedge areset) begin
    if (areset) begin // asynchronous reset to OFF state
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin // OFF state
                if (j == 1'b1) begin
                    state <= 2'b01; // transition to ON state if j is high
                end else begin
                    state <= 2'b00; // stay in OFF state if j is low
                end
            end
            2'b01: begin // ON state
                if (k == 1'b1) begin
                    state <= 2'b00; // transition to OFF state if k is high
                end else begin
                    state <= 2'b01; // stay in ON state if k is low
                end
            end
            default: begin
                state <= 2'b00; // default to OFF state if unknown state
            end
        endcase
    end
end

always @(*) begin
    case (state)
        2'b00: out = 1'b0; // output is 0 in OFF state
        2'b01: out = 1'b1; // output is 1 in ON state
        default: out = 1'b0; // default output to 0 if unknown state
    endcase
end

endmodule