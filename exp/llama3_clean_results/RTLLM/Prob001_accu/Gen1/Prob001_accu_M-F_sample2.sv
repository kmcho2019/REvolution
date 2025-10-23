module accu (
    input         clk,
    input         rst_n,
    input         valid_in,
    input  [7:0]  data_in,
    output        valid_out,
    output [9:0]  data_out
);

reg [1:0] state;
reg [1:0] next_state;
reg [9:0] accumulated_sum;
reg [9:0] next_accumulated_sum;
reg [1:0] counter;
reg [1:0] next_counter;
reg        valid_out_reg;
reg        next_valid_out;
reg        clk_enable;

// State machine states
parameter IDLE = 2'b00;
parameter ACCUMULATE = 2'b01;

// Initialize state and signals
initial begin
    state = IDLE;
    accumulated_sum = 10'b0;
    counter = 2'b0;
    valid_out_reg = 1'b0;
    clk_enable = 1'b0;
end

// Clock enable logic to reduce power
always @(*) begin
    if (state == IDLE || counter == 2'b11) begin
        clk_enable = 1'b0;
    end else begin
        clk_enable = 1'b1;
    end
end

// State machine logic
always @(*) begin
    next_state = state;
    next_accumulated_sum = accumulated_sum;
    next_counter = counter;
    next_valid_out = 1'b0;

    case (state)
        IDLE: begin
            if (valid_in) begin
                next_state = ACCUMULATE;
                next_accumulated_sum = data_in;
                next_counter = 2'b1;
            end
        end

        ACCUMULATE: begin
            if (valid_in) begin
                next_accumulated_sum = accumulated_sum + data_in;
                next_counter = counter + 1'b1;
            end

            if (counter == 2'b11) begin
                next_valid_out = 1'b1;
                next_state = IDLE;
                next_accumulated_sum = 10'b0;
                next_counter = 2'b0;
            end
        end

        default: next_state = IDLE;
    endcase
end

// Sequential logic with clock gating
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        accumulated_sum <= 10'b0;
        counter <= 2'b0;
        valid_out_reg <= 1'b0;
    end else if (clk_enable) begin
        state <= next_state;
        accumulated_sum <= next_accumulated_sum;
        counter <= next_counter;
        valid_out_reg <= next_valid_out;
    end
end

// Output logic
assign valid_out = valid_out_reg;
assign data_out = accumulated_sum;

endmodule