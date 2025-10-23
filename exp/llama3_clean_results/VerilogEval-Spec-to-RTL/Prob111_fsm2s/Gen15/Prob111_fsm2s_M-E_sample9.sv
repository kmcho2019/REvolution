module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output reg out
);

// State variable
reg [1:0] state;

// Output assignment based on state
always @(*) begin
    case(state)
        2'b00: out = 1'b0;
        2'b01: out = 1'b1;
        default: out = 1'bx;
    endcase
end

// Next state logic with synchronous reset
always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00;
    end else begin
        case(state)
            2'b00: state <= j ? 2'b01 : 2'b00;
            2'b01: state <= ~k ? 2'b01 : 2'b00;
            default: state <= 2'bx;
        endcase
    end
end

endmodule