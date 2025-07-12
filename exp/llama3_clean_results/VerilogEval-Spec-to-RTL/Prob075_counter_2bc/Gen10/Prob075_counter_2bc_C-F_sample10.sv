module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to calculate the next state
wire [1:0] next_state;
always @(*) begin
    case (state_reg)
        2'b00: begin
            if (train_valid && train_taken) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin
            if (train_valid && train_taken) begin
                next_state = 2'b10;
            end else if (train_valid && !train_taken) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b01;
            end
        end
        2'b10: begin
            if (train_valid && train_taken) begin
                next_state = 2'b11;
            end else if (train_valid && !train_taken) begin
                next_state = 2'b01;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin
            if (train_valid && !train_taken) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b11;
            end
        end
    endcase
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state;
    end
end

endmodule