module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define states for each prefix of the target sequence
reg [1:0] state;
localparam IDLE = 2'b00;
localparam STATE_1 = 2'b01;
localparam STATE_11 = 2'b10;
localparam STATE_110 = 2'b11;

// Initialize the FSM to the IDLE state
initial state = IDLE;

// Combinational logic for next state
always @(*) begin
    case(state)
        IDLE: state = data? STATE_1 : IDLE;
        STATE_1: state = data? STATE_11 : IDLE;
        STATE_11: state = ~data? STATE_110 : STATE_11;
        STATE_110: state = data? STATE_110 : IDLE;
        default: state = IDLE;
    endcase
end

// Synchronous reset and state update
always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        case(state)
            IDLE: begin
                if(data) begin
                    state <= STATE_1;
                end
            end
            STATE_1: begin
                if(data) begin
                    state <= STATE_11;
                end else begin
                    state <= IDLE;
                end
            end
            STATE_11: begin
                if(~data) begin
                    state <= STATE_110;
                end else begin
                    state <= STATE_11;
                end
            end
            STATE_110: begin
                if(data) begin
                    state <= IDLE;
                    start_shifting <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule