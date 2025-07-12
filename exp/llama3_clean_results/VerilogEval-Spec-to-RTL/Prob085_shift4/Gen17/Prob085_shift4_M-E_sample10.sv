// TopModule: Dual-mode 4-bit shift register with FSM and clock gating
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

// FSM states
enum logic [1:0] {IDLE, LOAD, SHIFT} state, next_state;

// 4-bit register
reg [3:0] reg_data;

// Clock-gating enable signal
reg clk_en;

// FSM and register logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to zero
        state <= IDLE;
        reg_data <= 4'b0;
        clk_en <= 1'b0;
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (load) begin
                    next_state <= LOAD;
                    clk_en <= 1'b1;
                end else if (ena) begin
                    next_state <= SHIFT;
                    clk_en <= 1'b1;
                end else begin
                    next_state <= IDLE;
                    clk_en <= 1'b0;
                end
            end
            LOAD: begin
                reg_data <= data;
                next_state <= IDLE;
                clk_en <= 1'b0;
            end
            SHIFT: begin
                reg_data <= {1'b0, reg_data[3:1]};
                next_state <= IDLE;
                clk_en <= 1'b0;
            end
            default: begin
                next_state <= IDLE;
                clk_en <= 1'b0;
            end
        endcase
    end
end

// Assign output
assign q = reg_data;

endmodule