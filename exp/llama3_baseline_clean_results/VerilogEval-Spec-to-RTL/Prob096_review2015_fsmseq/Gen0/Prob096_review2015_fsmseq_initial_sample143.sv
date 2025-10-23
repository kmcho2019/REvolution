module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

// Define states
parameter Idle = 4'b0000;
parameter Found1 = 4'b0001;
parameter Found11 = 4'b0010;
parameter Found110 = 4'b0011;
parameter Final = 4'b0100;

reg [3:0] state;
reg [3:0] next_state;

// Initialize output
assign start_shifting = (state == Final) ? 1'b1 : 1'b0;

// Next state logic
always @(*) begin
    case(state)
        Idle: begin
            if (data == 1'b1) next_state = Found1;
            else next_state = Idle;
        end
        Found1: begin
            if (data == 1'b1) next_state = Found11;
            else next_state = Idle;
        end
        Found11: begin
            if (data == 1'b0) next_state = Found110;
            else next_state = Found1;
        end
        Found110: begin
            if (data == 1'b1) next_state = Final;
            else next_state = Idle;
        end
        Final: begin
            next_state = Final;
        end
        default: next_state = Idle;
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) state <= Idle;
    else state <= next_state;
end

endmodule