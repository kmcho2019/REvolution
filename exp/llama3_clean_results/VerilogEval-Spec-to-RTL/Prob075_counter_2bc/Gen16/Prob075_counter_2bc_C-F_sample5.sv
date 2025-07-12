module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

// Define the states
localparam IDLE = 2'b00;
localparam LOW = 2'b01;
localparam MIDDLE = 2'b10;
localparam HIGH = 2'b11;

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to calculate the next state
reg [1:0] next_state;
always @(*) begin
    case (state_reg)
        IDLE: begin
            if (train_valid && train_taken) begin
                next_state = LOW;
            end else if (train_valid && !train_taken) begin
                next_state = IDLE;
            end else begin
                next_state = IDLE;
            end
        end
        LOW: begin
            if (train_valid && train_taken) begin
                next_state = MIDDLE;
            end else if (train_valid && !train_taken) begin
                next_state = IDLE;
            end else begin
                next_state = LOW;
            end
        end
        MIDDLE: begin
            if (train_valid && train_taken) begin
                next_state = HIGH;
            end else if (train_valid && !train_taken) begin
                next_state = LOW;
            end else begin
                next_state = MIDDLE;
            end
        end
        HIGH: begin
            if (train_valid && train_taken) begin
                next_state = HIGH;
            end else if (train_valid && !train_taken) begin
                next_state = MIDDLE;
            end else begin
                next_state = HIGH;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= LOW; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

endmodule