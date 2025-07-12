module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

typedef enum logic [1:0] {
    Idle    = 2'b00,
    Seen1   = 2'b01,
    Seen101 = 2'b10
} state_t;

state_t state, next_state;

always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        Idle: begin
            if (x) begin
                next_state = Seen1;
            end else begin
                next_state = Idle;
            end
        end
        Seen1: begin
            if (~x) begin
                next_state = Seen101;
            end else begin
                next_state = Seen1;
            end
        end
        Seen101: begin
            if (x) begin
                next_state = Seen1;
            end else begin
                next_state = Idle;
            end
        end
        default: next_state = Idle;
    endcase
end

always_comb begin
    case (state)
        Idle: z = 1'b0;
        Seen1: z = 1'b0;
        Seen101: z = x;
        default: z = 1'b0;
    endcase
end

endmodule