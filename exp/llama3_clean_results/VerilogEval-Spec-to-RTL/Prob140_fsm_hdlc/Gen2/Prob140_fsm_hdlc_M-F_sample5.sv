module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states as logic vectors
logic [1:0] state, next_state;
logic [2:0] count, next_count;

// State encoding
parameter IDLE = 2'b00, COUNT = 2'b01, FLAG = 2'b10, ERR = 2'b11;

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 3'b000;
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
                next_count = 3'b001;
            end
        end
        COUNT: begin
            if (in) begin
                next_count = count + 3'b001;
                if (count == 3'b101) begin // 5 consecutive 1s
                    if (~in) begin
                        next_state = FLAG;
                        next_count = 3'b000;
                    end else if (count >= 3'b110) begin // 6 or more consecutive 1s
                        next_state = ERR;
                    end
                end else if (count >= 3'b110) begin // 6 or more consecutive 1s
                    next_state = ERR;
                end
            end else begin
                next_state = IDLE;
                next_count = 3'b000;
            end
        end
        FLAG: begin
            next_state = IDLE;
            next_count = 3'b000;
        end
        ERR: begin
            if (~in) begin
                next_state = IDLE;
                next_count = 3'b000;
            end
        end
    endcase
end

// Output logic
assign disc = (state == COUNT && count == 3'b101 && ~in);
assign flag = (state == FLAG);
assign err = (state == ERR);

endmodule