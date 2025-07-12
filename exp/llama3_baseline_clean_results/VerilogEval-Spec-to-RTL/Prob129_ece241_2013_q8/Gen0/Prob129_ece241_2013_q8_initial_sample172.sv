module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state, next_state;

localparam [1:0] Idle = 2'b00;
localparam [1:0] Seen1 = 2'b01;
localparam [1:0] Seen10 = 2'b10;

always @(*) begin
    case (state)
        Idle: next_state = (x) ? Seen1 : Idle;
        Seen1: next_state = (x) ? Seen1 : Seen10;
        Seen10: next_state = (x) ? Idle : Seen10;
        default: next_state = Idle;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        Idle: z = 1'b0;
        Seen1: z = 1'b0;
        Seen10: z = (x) ? 1'b1 : 1'b0;
        default: z = 1'b0;
    endcase
end

endmodule