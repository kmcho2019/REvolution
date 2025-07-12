module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states
localparam IDLE = 2'b00;
localparam FOUND_1 = 2'b01;
localparam FOUND_11 = 2'b10;
localparam FOUND_110 = 2'b11;
localparam FOUND_SEQUENCE = 2'b01; // reuse FOUND_1 state code for found_sequence

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin
    case (state)
        IDLE: 
            if (data) 
                next_state = FOUND_1;
            else 
                next_state = IDLE;
        FOUND_1: 
            if (data) 
                next_state = FOUND_11;
            else 
                next_state = IDLE;
        FOUND_11: 
            if (~data) 
                next_state = FOUND_110;
            else 
                next_state = FOUND_1;
        FOUND_110: 
            if (data) 
                next_state = FOUND_SEQUENCE;
            else 
                next_state = IDLE;
        FOUND_SEQUENCE: 
            next_state = FOUND_SEQUENCE;
        default: 
            next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 0;
    end else begin
        state <= next_state;
        if (next_state == FOUND_SEQUENCE)
            start_shifting <= 1;
        else if (next_state == IDLE)
            start_shifting <= 0;
    end
end

endmodule