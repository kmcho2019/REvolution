module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

reg [1:0] state;
reg [1:0] next_state;

localparam [1:0] Idle = 2'b00;
localparam [1:0] Seen1 = 2'b01;
localparam [1:0] Seen10 = 2'b10;

always @ (*) begin
    case (state)
        Idle: begin
            if (x == 1'b1) begin
                next_state = Seen1;
                z = 1'b0;
            end else begin
                next_state = Idle;
                z = 1'b0;
            end
        end
        Seen1: begin
            if (x == 1'b0) begin
                next_state = Seen10;
                z = 1'b0;
            end else begin
                next_state = Seen1;
                z = 1'b0;
            end
        end
        Seen10: begin
            if (x == 1'b1) begin
                next_state = Seen1;
                z = 1'b1;
            end else begin
                next_state = Idle;
                z = 1'b0;
            end
        end
        default: begin
            next_state = Idle;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

endmodule