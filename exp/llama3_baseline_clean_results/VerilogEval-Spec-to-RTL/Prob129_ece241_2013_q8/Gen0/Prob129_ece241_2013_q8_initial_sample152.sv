module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state; // Idle (2'b00), Seen1 (2'b01), Seen10 (2'b10)
reg [1:0] next_state;

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
        z <= 1'b0;
    end else begin
        state <= next_state;
        if (next_state == 2'b10 && x == 1'b1) begin
            z <= 1'b1;
        end else begin
            z <= 1'b0;
        end
    end
end

always @(*) begin
    case(state)
        2'b00: begin // Idle
            if (x == 1'b1) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // Seen1
            if (x == 1'b0) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin // Seen10
            if (x == 1'b1) begin
                next_state = 2'b00; // back to idle, z will be set to 1 in the always @(posedge clk) block
            end else begin
                next_state = 2'b00;
            end
        end
    endcase
end

endmodule