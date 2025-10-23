module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define state names as parameters
parameter IDLE = 0,
           S1 = 1,
           S2 = 2,
           S3 = 3,
           FOUND = 4;

// Define current state and next state
reg [2:0] current_state, next_state;

// Initial state
initial current_state = IDLE;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == FOUND) begin
            start_shifting <= 1;
        end else if (current_state == IDLE && next_state == IDLE) begin
            start_shifting <= 0;
        end
    end
end

// Combinational logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (~data) begin
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S3: begin
            if (data) begin
                next_state = FOUND;
            end else begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule