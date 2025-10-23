module TopModule(
    input clk,
    input reset_n,
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

// State encoding
localparam OFF      = 2'b00;
localparam HEATING  = 2'b01;
localparam COOLING  = 2'b10;

reg [1:0] state, next_state;

// State transition logic (combinational)
always @(*) begin
    case(state)
        OFF: begin
            if (mode == 1'b1 && too_cold)
                next_state = HEATING;
            else if (mode == 1'b0 && too_hot)
                next_state = COOLING;
            else
                next_state = OFF;
        end
        HEATING: begin
            if (mode == 1'b1 && too_cold)
                next_state = HEATING;
            else
                next_state = OFF;
        end
        COOLING: begin
            if (mode == 1'b0 && too_hot)
                next_state = COOLING;
            else
                next_state = OFF;
        end
        default: next_state = OFF;
    endcase
end

// State register update
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        state <= OFF;
    else
        state <= next_state;
end

// Output logic based on state and inputs
always @(*) begin
    heater = (state == HEATING);
    aircon = (state == COOLING);
    fan = heater | aircon | fan_on;
end

endmodule