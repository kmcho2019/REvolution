module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
parameter IDLE = 2'b00;
parameter SEEN1 = 2'b01;
parameter SEEN10 = 2'b10;

// Register to hold the current state
reg [1:0] state, next_state;

// Output register
reg z_reg, z_next;

// State machine
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = SEEN1;
                z_next = 1'b0;
            end else begin
                next_state = IDLE;
                z_next = 1'b0;
            end
        end
        SEEN1: begin
            if (!x) begin
                next_state = SEEN10;
                z_next = 1'b0;
            end else begin
                next_state = SEEN1;
                z_next = 1'b0;
            end
        end
        SEEN10: begin
            if (x) begin
                next_state = SEEN10;
                z_next = 1'b1;
            end else begin
                next_state = SEEN1;
                z_next = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z_next = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= IDLE;
        z_reg <= 1'b0;
    end else begin
        state <= next_state;
        z_reg <= z_next;
    end
end

// Continuous assignment for output
assign z = z_reg;

endmodule