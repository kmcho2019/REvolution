module pulse_detect(
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] state; // 2-bit register to keep track of the current state
localparam IDLE = 2'b00; // Initial state
localparam RISING = 2'b01; // State after data_in rises
localparam HIGH = 2'b10; // State after data_in remains high
localparam FALLING = 2'b11; // State after data_in falls

// Asynchronous reset
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (data_in) begin
                    state <= RISING;
                end
            end
            RISING: begin
                if (data_in) begin
                    state <= HIGH;
                end else begin
                    state <= IDLE;
                end
            end
            HIGH: begin
                if (~data_in) begin
                    state <= FALLING;
                end
            end
            FALLING: begin
                state <= IDLE;
            end
        endcase
    end
end

// Combinational logic for data_out
always @(*) begin
    if (state == FALLING) begin
        data_out = 1;
    end else begin
        data_out = 0;
    end
end

endmodule