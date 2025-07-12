module TopModule(
    input clk,
    input load,
    input [9:0] data,
    output tc
);

// State definition
enum {IDLE, COUNTING} state, next_state;

// Counter and terminal count signal
reg [9:0] counter;
reg tc_reg;
assign tc = tc_reg;

// Initialize state and counter
initial begin
    state = IDLE;
    counter = 10'd0;
    tc_reg = 1'b0;
end

// State transition and counter logic
always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (load) begin
                counter <= data;
                next_state <= COUNTING;
            end else begin
                next_state <= IDLE;
            end
        end
        COUNTING: begin
            if (counter == 10'd0) begin
                tc_reg <= 1'b1;
                next_state <= IDLE;
            end else if (load) begin
                counter <= data;
            end else begin
                counter <= counter - 1;
            end
        end
    endcase
    state <= next_state;
end

// Reset tc when loading new value
always @(posedge clk) begin
    if (load) begin
        tc_reg <= 1'b0;
    end
end

endmodule