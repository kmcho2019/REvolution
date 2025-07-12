module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states as enumeration values
enum logic [1:0] {
    IDLE,
    COUNT,
    FLAG,
    ERR
} state, next_state;

// Counter to track consecutive 1s
logic [2:0] count, next_count;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
    end else begin
        state <= next_state;
        count <= next_count;
    end
end

// Next state logic
always_comb begin
    next_state = state;
    next_count = count;
    case (state)
        IDLE: begin
            if (in) begin
                next_state = COUNT;
                next_count = 1;
            end
        end
        COUNT: begin
            if (in) begin
                next_count = count + 1;
                if (count == 5) begin
                    next_state = (in == 0)? FLAG : ERR;
                    next_count = 0;
                end else if (count >= 6) begin
                    next_state = ERR;
                end
            end else begin
                next_state = IDLE;
                next_count = 0;
            end
        end
        FLAG: begin
            next_state = IDLE;
            next_count = 0;
        end
        ERR: begin
            if (~in) begin
                next_state = IDLE;
                next_count = 0;
            end
        end
    endcase
end

// Output logic
assign disc = (state == COUNT && count == 5 && in == 0);
assign flag = (state == FLAG);
assign err = (state == ERR);

endmodule