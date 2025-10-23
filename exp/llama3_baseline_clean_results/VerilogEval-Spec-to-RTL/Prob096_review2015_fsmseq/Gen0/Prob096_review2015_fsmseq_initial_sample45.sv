module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] state; // idle (0), saw1 (1), saw11 (2), saw110 (3), found (4) (not using enum for simplicity)
localparam IDLE = 2'b00;
localparam SAW1 = 2'b01;
localparam SAW11 = 2'b10;
localparam SAW110 = 2'b11;
localparam FOUND = 2'b12; // Note: Verilog allows 2 bits to be represented as 4 distinct states, but we use it as 5 distinct states for our FSM

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data == 1) state <= SAW1;
                else state <= IDLE;
            end
            SAW1: begin
                if(data == 1) state <= SAW11;
                else if(data == 0) state <= IDLE;
            end
            SAW11: begin
                if(data == 0) state <= SAW110;
                else if(data == 1) state <= SAW1;
            end
            SAW110: begin
                if(data == 1) state <= FOUND;
                else if(data == 0) state <= IDLE;
            end
            FOUND: begin
                start_shifting <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if(reset) start_shifting <= 0;
    else if(state == FOUND) start_shifting <= 1;
end

endmodule