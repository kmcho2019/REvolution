module TopModule(
    input clk,
    input reset,
    output [9:0] q
);

typedef enum {COUNTING, RESET} state_t;
state_t current_state, next_state;

reg [9:0] count;

always @(posedge clk) begin
    if (reset) begin
        current_state <= RESET;
        count <= 10'd0;
    end else begin
        current_state <= next_state;
        case (current_state)
            COUNTING: begin
                if (count == 10'd999) begin
                    count <= 10'd0;
                end else begin
                    count <= count + 1;
                end
            end
            RESET: begin
                count <= 10'd0;
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
        COUNTING: begin
            if (count == 10'd999) begin
                next_state = RESET;
            end else begin
                next_state = COUNTING;
            end
        end
        RESET: begin
            next_state = COUNTING;
        end
    endcase
end

assign q = count;

initial begin
    current_state = COUNTING;
end

endmodule