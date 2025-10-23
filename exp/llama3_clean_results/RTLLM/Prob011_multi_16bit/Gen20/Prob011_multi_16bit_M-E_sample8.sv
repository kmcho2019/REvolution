module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE,
    SHIFT,
    AND_OP,
    ADD_OP,
    DONE
} state, next_state;

// Define the pipeline registers
reg [15:0] ain_reg;
reg [15:0] bin_reg;
reg [31:0] yout_reg;

// Define the partial product register
reg [31:0] partial_product;

// Define the clock enable signal
reg clock_enable;

// FSM logic
always @(posedge clk) begin
    if (!rst_n) begin
        state <= IDLE;
        clock_enable <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= SHIFT;
                    clock_enable <= 1'b1;
                end
            end
            SHIFT: begin
                if (ain_reg == 16'd0) begin
                    state <= AND_OP;
                end else begin
                    ain_reg <= ain_reg >> 1;
                end
            end
            AND_OP: begin
                partial_product <= partial_product + (bin_reg & ain_reg);
                state <= ADD_OP;
            end
            ADD_OP: begin
                yout_reg <= yout_reg + partial_product;
                state <= DONE;
            end
            DONE: begin
                done <= 1'b1;
                clock_enable <= 1'b0;
                state <= IDLE;
            end
        endcase
    end
end

// Pipeline logic
always @(posedge clk) begin
    if (clock_enable) begin
        case (state)
            IDLE: begin
                ain_reg <= ain;
                bin_reg <= bin;
            end
            SHIFT: begin
                // No operation
            end
            AND_OP: begin
                // No operation
            end
            ADD_OP: begin
                // No operation
            end
            DONE: begin
                yout <= yout_reg;
            end
        endcase
    end
end

endmodule